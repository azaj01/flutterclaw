/// Plugin lifecycle service.
///
/// Extends the skills platform to support full multi-artifact plugins:
/// skills, hooks, commands, and MCP configs. Plugins are stored in
/// workspace/plugins/ with a plugin.json manifest.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutterclaw/data/models/config.dart';
import 'package:flutterclaw/data/models/plugin_manifest.dart';
import 'package:flutterclaw/services/hook_runner.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

final _log = Logger('flutterclaw.plugins');

/// Manages the full lifecycle of FlutterClaw plugins.
///
/// A plugin is a directory under `workspace/plugins/<plugin-id>/` containing:
/// - `plugin.json` — the manifest (required)
/// - `SKILL.md` — skill prompt (if the plugin has skill artifacts)
/// - `hooks.json` — hook definitions (if the plugin has hook artifacts)
///
/// Plugins that only contain a SKILL.md (no plugin.json) are also supported
/// for backwards compatibility with the existing skills format.
class PluginService {
  final ConfigManager configManager;
  final HookRunner? hookRunner;

  final List<PluginManifest> _plugins = [];

  PluginService({required this.configManager, this.hookRunner});

  List<PluginManifest> get plugins => List.unmodifiable(_plugins);
  List<PluginManifest> get enabledPlugins =>
      _plugins.where((p) => p.enabled).toList();

  // -- Loading -----------------------------------------------------------------

  /// Scan the plugins directory and load all plugin manifests.
  Future<void> loadPlugins() async {
    _plugins.clear();

    final ws = await configManager.workspacePath;
    final pluginsDir = Directory(p.join(ws, 'plugins'));
    if (!await pluginsDir.exists()) return;

    await for (final entity in pluginsDir.list()) {
      if (entity is! Directory) continue;
      final manifestFile = File(p.join(entity.path, 'plugin.json'));
      if (!await manifestFile.exists()) continue;

      try {
        final json =
            jsonDecode(await manifestFile.readAsString()) as Map<String, dynamic>;
        final manifest = PluginManifest.fromJson(json)
          ..installedPath = entity.path;
        _plugins.add(manifest);
        _log.fine('Loaded plugin: ${manifest.name} v${manifest.version}');
      } catch (e) {
        _log.warning('Failed to load plugin at ${entity.path}: $e');
      }
    }

    _log.info('Loaded ${_plugins.length} plugins');

    // Wire enabled plugins into HookRunner
    if (hookRunner != null) {
      await _registerHooks();
    }
  }

  /// Build a combined skills prompt from all enabled plugins that have skill
  /// artifacts. This is appended to the system prompt alongside regular skills.
  Future<String> getPluginSkillsPrompt() async {
    final buf = StringBuffer();
    for (final plugin in enabledPlugins) {
      final skillArtifacts = plugin.skills;
      if (skillArtifacts.isEmpty || plugin.installedPath == null) continue;

      for (final artifact in skillArtifacts) {
        final skillFile =
            File(p.join(plugin.installedPath!, artifact.path));
        if (!await skillFile.exists()) continue;
        try {
          final content = await skillFile.readAsString();
          buf.writeln(content);
        } catch (e) {
          _log.warning('Failed to read skill ${artifact.path} from ${plugin.id}: $e');
        }
      }
    }
    return buf.toString();
  }

  // -- Hook registration -------------------------------------------------------

  Future<void> _registerHooks() async {
    // Remove previously plugin-registered hooks
    for (final plugin in _plugins) {
      hookRunner!.unregister('plugin:${plugin.id}:*');
    }

    for (final plugin in enabledPlugins) {
      final hookArtifacts = plugin.hooks;
      if (hookArtifacts.isEmpty || plugin.installedPath == null) continue;

      for (final artifact in hookArtifacts) {
        final hookFile = File(p.join(plugin.installedPath!, artifact.path));
        if (!await hookFile.exists()) continue;

        try {
          final raw = jsonDecode(await hookFile.readAsString());
          final hookDefs = raw is List
              ? raw.cast<Map<String, dynamic>>()
              : [raw as Map<String, dynamic>];

          for (final def in hookDefs) {
            _registerHookDef(plugin.id, def);
          }
        } catch (e) {
          _log.warning(
              'Failed to load hooks from ${artifact.path} in ${plugin.id}: $e');
        }
      }
    }
  }

  void _registerHookDef(String pluginId, Map<String, dynamic> def) {
    final eventStr = def['event'] as String? ?? '';
    final event = switch (eventStr) {
      'pre_tool_use' => HookEvent.preToolUse,
      'post_tool_use' => HookEvent.postToolUse,
      'session_start' => HookEvent.sessionStart,
      'session_stop' => HookEvent.sessionStop,
      'pre_compact' => HookEvent.preCompact,
      'post_compact' => HookEvent.postCompact,
      _ => null,
    };
    if (event == null) {
      _log.warning('Plugin $pluginId: unknown hook event "$eventStr"');
      return;
    }

    final matcher = def['matcher'] as String?;
    final block = def['block'] as bool? ?? false;
    final message = def['message'] as String? ?? '';
    final hookName = 'plugin:$pluginId:${def['name'] ?? eventStr}';

    hookRunner!.register(HookDefinition(
      name: hookName,
      event: event,
      toolMatcher: matcher != null ? RegExp(matcher) : null,
      callback: (_) async {
        if (block) {
          return HookResult.block(
              message.isNotEmpty ? message : 'Blocked by plugin $pluginId');
        }
        return HookResult.permitted;
      },
    ));

    _log.fine('Registered hook $hookName for event $eventStr');
  }

  // -- CRUD --------------------------------------------------------------------

  /// Install a plugin from an existing directory path.
  ///
  /// Copies the directory to `workspace/plugins/<plugin-id>/` and loads it.
  Future<PluginManifest> installFromPath(String sourcePath) async {
    final manifestFile = File(p.join(sourcePath, 'plugin.json'));
    if (!await manifestFile.exists()) {
      throw ArgumentError(
          'No plugin.json found at $sourcePath — is this a valid plugin?');
    }

    final json =
        jsonDecode(await manifestFile.readAsString()) as Map<String, dynamic>;
    final manifest = PluginManifest.fromJson(json);

    final ws = await configManager.workspacePath;
    final destPath = p.join(ws, 'plugins', manifest.id);
    final destDir = Directory(destPath);

    // Remove any existing installation with the same id
    if (await destDir.exists()) {
      await destDir.delete(recursive: true);
    }

    // Copy entire plugin directory
    await _copyDirectory(Directory(sourcePath), destDir);

    manifest.installedPath = destPath;
    _plugins.removeWhere((p) => p.id == manifest.id);
    _plugins.add(manifest);

    if (hookRunner != null && manifest.enabled) {
      await _registerHooks();
    }

    _log.info('Installed plugin: ${manifest.name} v${manifest.version}');
    return manifest;
  }

  /// Enable or disable a plugin by id.
  Future<void> setEnabled(String pluginId, {required bool enabled}) async {
    final manifest = _plugins.firstWhere((p) => p.id == pluginId,
        orElse: () => throw ArgumentError('Plugin $pluginId not found'));
    manifest.enabled = enabled;

    // Persist the enabled state to plugin.json
    await _saveManifest(manifest);

    if (hookRunner != null) {
      await _registerHooks();
    }
  }

  /// Remove a plugin by id. Deletes the directory from disk.
  Future<void> remove(String pluginId) async {
    final manifest = _plugins.firstWhere((p) => p.id == pluginId,
        orElse: () => throw ArgumentError('Plugin $pluginId not found'));

    if (manifest.installedPath != null) {
      final dir = Directory(manifest.installedPath!);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    }

    _plugins.removeWhere((p) => p.id == pluginId);

    if (hookRunner != null) {
      hookRunner!.unregister('plugin:$pluginId:*');
    }

    _log.info('Removed plugin: $pluginId');
  }

  // -- Private helpers ---------------------------------------------------------

  Future<void> _saveManifest(PluginManifest manifest) async {
    if (manifest.installedPath == null) return;
    final file = File(p.join(manifest.installedPath!, 'plugin.json'));
    final encoder = const JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(manifest.toJson()));
  }

  Future<void> _copyDirectory(Directory source, Directory dest) async {
    await dest.create(recursive: true);
    await for (final entity in source.list(recursive: false)) {
      final destChild = p.join(dest.path, p.basename(entity.path));
      if (entity is Directory) {
        await _copyDirectory(entity, Directory(destChild));
      } else if (entity is File) {
        await entity.copy(destChild);
      }
    }
  }
}
