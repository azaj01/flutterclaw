/// Agent management tools — create, update, and delete permanent agents.
///
/// Ports OpenClaw's config.patch / ensureAgentWorkspace pattern to mobile:
/// instead of patching a JSON config via a gateway tool, these tools directly
/// call ConfigManager (which already owns the agent roster + workspace seeding)
/// and signal Riverpod via [onConfigChanged] to invalidate derived providers.
///
/// An agent created with [AgentCreateTool] gets:
///   - A new [AgentProfile] entry persisted in config.json
///   - An isolated workspace directory seeded with IDENTITY.md, SOUL.md,
///     TOOLS.md, AGENTS.md, USER.md, HEARTBEAT.md, BOOTSTRAP.md, memory/
///   - Its own session namespace  ("webchat:{id}")
///   - Its own file-system root under   configDir/agents/{uuid}/
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutterclaw/data/models/agent_profile.dart';
import 'package:flutterclaw/data/models/config.dart';
import 'package:flutterclaw/tools/registry.dart';

// ---------------------------------------------------------------------------
// agent_create
// ---------------------------------------------------------------------------

class AgentCreateTool extends Tool {
  final ConfigManager configManager;

  /// Called after the config is mutated so Riverpod providers rebuild.
  final void Function() onConfigChanged;

  AgentCreateTool({
    required this.configManager,
    required this.onConfigChanged,
  });

  @override
  String get name => 'agent_create';

  @override
  String get description =>
      'Create a new permanent agent with its own isolated workspace. '
      'The agent is added to the config roster and its workspace is seeded '
      'with IDENTITY.md, SOUL.md, BOOTSTRAP.md and other template files — '
      'exactly like the built-in agents. '
      'After creation the agent can be targeted with sessions_spawn, '
      'agent_send, or sessions_send using its agentId or session key.\n\n'
      'Parameters:\n'
      '- name (required): Display name, e.g. "Researcher"\n'
      '- emoji (optional): Single emoji, default 🤖\n'
      '- model (optional): Model name; defaults to the current active model\n'
      '- vibe (optional): Personality descriptor, e.g. "analytical and concise"\n'
      '- system_prompt (optional): Custom system-prompt override for this agent';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'name': {
            'type': 'string',
            'description': 'Display name for the new agent (must be unique)',
          },
          'emoji': {
            'type': 'string',
            'description': 'Single emoji that represents the agent (default: 🤖)',
          },
          'model': {
            'type': 'string',
            'description':
                'LLM model name for this agent. '
                'Defaults to the current active agent\'s model if omitted.',
          },
          'vibe': {
            'type': 'string',
            'description':
                'Short personality descriptor used in SOUL.md, '
                'e.g. "analytical and concise" or "warm and creative"',
          },
          'system_prompt': {
            'type': 'string',
            'description': 'Optional custom system-prompt override for this agent',
          },
        },
        'required': ['name'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    final name = (arguments['name'] as String?)?.trim() ?? '';
    if (name.isEmpty) {
      return ToolResult.error('name is required');
    }

    final emoji = (arguments['emoji'] as String?)?.trim().isNotEmpty == true
        ? (arguments['emoji'] as String).trim()
        : '🤖';
    final vibe = (arguments['vibe'] as String?)?.trim();
    final systemPrompt = (arguments['system_prompt'] as String?)?.trim();

    // Resolve model: explicit arg → active agent model → first configured model
    final explicitModel = (arguments['model'] as String?)?.trim();
    final modelName = explicitModel?.isNotEmpty == true
        ? explicitModel!
        : configManager.config.activeAgent?.modelName ??
          configManager.config.agents.defaults.modelName;

    // Reject duplicate names (case-insensitive)
    final nameLower = name.toLowerCase();
    final duplicate = configManager.config.agentProfiles
        .any((a) => a.name.toLowerCase() == nameLower);
    if (duplicate) {
      return ToolResult.error(
          'An agent named "$name" already exists. '
          'Choose a different name or use agent_update to modify the existing one.');
    }

    try {
      final agent = AgentProfile.create(
        name: name,
        emoji: emoji,
        modelName: modelName,
        vibe: vibe,
        systemPromptOverride: systemPrompt?.isNotEmpty == true ? systemPrompt : null,
      );

      // Seed the workspace directory with all template files
      await configManager.createAgentWorkspace(agent);

      // Persist to config
      final updated = configManager.config.copyWith(
        agentProfiles: [...configManager.config.agentProfiles, agent],
      );
      configManager.update(updated);
      await configManager.save();
      onConfigChanged();

      final sessionKey = 'webchat:${agent.id}';
      return ToolResult.success(jsonEncode({
        'success': true,
        'agentId': agent.id,
        'name': agent.name,
        'emoji': agent.emoji,
        'model': agent.modelName,
        'workspacePath': agent.workspacePath,
        'sessionKey': sessionKey,
        'note':
            'Agent "${agent.name}" ${agent.emoji} created. '
            'Switch to it with agent_switch, or spawn a task with '
            'sessions_spawn(task: "...", agentId: "${agent.id}").',
      }));
    } catch (e) {
      return ToolResult.error('Failed to create agent: $e');
    }
  }
}

// ---------------------------------------------------------------------------
// agent_update
// ---------------------------------------------------------------------------

class AgentUpdateTool extends Tool {
  final ConfigManager configManager;
  final void Function() onConfigChanged;

  AgentUpdateTool({
    required this.configManager,
    required this.onConfigChanged,
  });

  @override
  String get name => 'agent_update';

  @override
  String get description =>
      'Update a permanent agent\'s profile (name, emoji, model, vibe, or system prompt). '
      'Also rewrites IDENTITY.md in the agent workspace when name or emoji changes. '
      'Only the fields you supply are changed; omitted fields stay the same.\n\n'
      'Parameters:\n'
      '- agent_id (required): The ID of the agent to update\n'
      '- name, emoji, model, vibe, system_prompt (optional): Fields to change';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'agent_id': {
            'type': 'string',
            'description': 'ID of the agent to update',
          },
          'name': {'type': 'string', 'description': 'New display name'},
          'emoji': {'type': 'string', 'description': 'New single emoji'},
          'model': {'type': 'string', 'description': 'New LLM model name'},
          'vibe': {'type': 'string', 'description': 'New personality descriptor'},
          'system_prompt': {
            'type': 'string',
            'description': 'New system-prompt override (empty string to remove)',
          },
        },
        'required': ['agent_id'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    final agentId = (arguments['agent_id'] as String?)?.trim() ?? '';
    if (agentId.isEmpty) {
      return ToolResult.error('agent_id is required');
    }

    final existing = configManager.config.agentProfiles
        .where((a) => a.id == agentId)
        .firstOrNull;
    if (existing == null) {
      return ToolResult.error('Agent not found: $agentId');
    }

    final newName = (arguments['name'] as String?)?.trim();
    final newEmoji = (arguments['emoji'] as String?)?.trim();
    final newModel = (arguments['model'] as String?)?.trim();
    final newVibe = (arguments['vibe'] as String?)?.trim();
    // An explicitly empty string means "remove the override"
    final systemPromptRaw = arguments['system_prompt'] as String?;
    final newSystemPrompt = systemPromptRaw != null
        ? (systemPromptRaw.trim().isEmpty ? null : systemPromptRaw.trim())
        : existing.systemPromptOverride;

    // Name uniqueness check (excluding self)
    if (newName != null && newName.isNotEmpty) {
      final nameLower = newName.toLowerCase();
      final collision = configManager.config.agentProfiles
          .any((a) => a.id != agentId && a.name.toLowerCase() == nameLower);
      if (collision) {
        return ToolResult.error('Another agent named "$newName" already exists.');
      }
    }

    try {
      final updated = existing.copyWith(
        name: newName?.isNotEmpty == true ? newName : null,
        emoji: newEmoji?.isNotEmpty == true ? newEmoji : null,
        modelName: newModel?.isNotEmpty == true ? newModel : null,
        vibe: newVibe?.isNotEmpty == true ? newVibe : null,
        systemPromptOverride: newSystemPrompt,
        lastUsedAt: DateTime.now(),
      );

      // Rewrite IDENTITY.md in the workspace if identity fields changed
      if ((newName != null && newName.isNotEmpty) ||
          (newEmoji != null && newEmoji.isNotEmpty) ||
          (newVibe != null && newVibe.isNotEmpty)) {
        await _updateIdentityFile(updated);
      }

      final updatedProfiles = configManager.config.agentProfiles
          .map((a) => a.id == agentId ? updated : a)
          .toList();
      configManager.update(
          configManager.config.copyWith(agentProfiles: updatedProfiles));
      await configManager.save();
      onConfigChanged();

      return ToolResult.success(jsonEncode({
        'success': true,
        'agentId': updated.id,
        'name': updated.name,
        'emoji': updated.emoji,
        'model': updated.modelName,
        'vibe': updated.vibe,
        'changes': {
          if (newName != null && newName.isNotEmpty) 'name': newName,
          if (newEmoji != null && newEmoji.isNotEmpty) 'emoji': newEmoji,
          if (newModel != null && newModel.isNotEmpty) 'model': newModel,
          if (newVibe != null && newVibe.isNotEmpty) 'vibe': newVibe,
          if (systemPromptRaw != null) 'system_prompt': newSystemPrompt ?? '(removed)',
        },
      }));
    } catch (e) {
      return ToolResult.error('Failed to update agent: $e');
    }
  }

  Future<void> _updateIdentityFile(AgentProfile agent) async {
    try {
      final base = await configManager.configDir;
      final identityPath = '$base/${agent.workspacePath}/IDENTITY.md';
      final file = File(identityPath);
      if (!await file.exists()) return;

      final content = '''# Identity

Name: ${agent.name}
Emoji: ${agent.emoji}
Vibe: ${agent.vibe ?? 'helpful and friendly'}
Type: Personal AI Assistant
Model: ${agent.modelName}
''';
      await file.writeAsString(content);
    } catch (_) {
      // Non-fatal: workspace may not exist yet or may have been customised
    }
  }
}

// ---------------------------------------------------------------------------
// agent_delete
// ---------------------------------------------------------------------------

class AgentDeleteTool extends Tool {
  final ConfigManager configManager;
  final void Function() onConfigChanged;

  AgentDeleteTool({
    required this.configManager,
    required this.onConfigChanged,
  });

  @override
  String get name => 'agent_delete';

  @override
  String get description =>
      'Permanently delete an agent and archive its workspace. '
      'Cannot delete the currently active agent or the last remaining agent. '
      'The workspace directory is renamed to workspace-{id}-deleted-{timestamp} '
      'rather than erased, so data can be recovered manually.\n\n'
      'Parameters:\n'
      '- agent_id (required): ID of the agent to delete\n'
      '- confirm (required): Must be true to execute the deletion';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'agent_id': {
            'type': 'string',
            'description': 'ID of the agent to delete',
          },
          'confirm': {
            'type': 'boolean',
            'description': 'Must be true to confirm deletion',
          },
        },
        'required': ['agent_id', 'confirm'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    final agentId = (arguments['agent_id'] as String?)?.trim() ?? '';
    final confirm = arguments['confirm'] as bool? ?? false;

    if (agentId.isEmpty) {
      return ToolResult.error('agent_id is required');
    }
    if (!confirm) {
      return ToolResult.error(
          'confirm must be true to delete an agent. '
          'This is irreversible — the workspace will be archived.');
    }

    final agent = configManager.config.agentProfiles
        .where((a) => a.id == agentId)
        .firstOrNull;
    if (agent == null) {
      return ToolResult.error('Agent not found: $agentId');
    }

    final profiles = configManager.config.agentProfiles;
    if (profiles.length <= 1) {
      return ToolResult.error(
          'Cannot delete the last agent. Create a replacement first with agent_create.');
    }

    final activeId = configManager.config.activeAgentId ??
        configManager.config.activeAgent?.id;
    if (agentId == activeId) {
      return ToolResult.error(
          'Cannot delete the currently active agent. '
          'Switch to a different agent first, then delete this one.');
    }

    try {
      // Archive workspace (rename, do not delete)
      String? archivedPath;
      final base = await configManager.configDir;
      final wsPath = '$base/${agent.workspacePath}';
      final wsDir = Directory(wsPath);
      if (await wsDir.exists()) {
        final ts = DateTime.now().millisecondsSinceEpoch;
        final archivePath =
            '$base/agents/$agentId-deleted-$ts';
        await wsDir.rename(archivePath);
        archivedPath = archivePath;
      }

      // Remove from config
      final updatedProfiles =
          profiles.where((a) => a.id != agentId).toList();
      configManager.update(
          configManager.config.copyWith(agentProfiles: updatedProfiles));
      await configManager.save();
      onConfigChanged();

      return ToolResult.success(jsonEncode({
        'success': true,
        'deletedAgentId': agentId,
        'deletedAgentName': agent.name,
        'archivedWorkspace': archivedPath,
        'note':
            'Agent "${agent.name}" deleted. '
            'Workspace archived at ${archivedPath ?? "(not found)"}.',
      }));
    } catch (e) {
      return ToolResult.error('Failed to delete agent: $e');
    }
  }
}

// ---------------------------------------------------------------------------
// agent_switch
// ---------------------------------------------------------------------------

/// Switches the active agent in the config.
///
/// The UI picks up the change via [onConfigChanged] and any
/// subsequent [ChatNotifier.switchToAgent] call.
class AgentSwitchTool extends Tool {
  final ConfigManager configManager;
  final void Function() onConfigChanged;

  AgentSwitchTool({
    required this.configManager,
    required this.onConfigChanged,
  });

  @override
  String get name => 'agent_switch';

  @override
  String get description =>
      'Switch the active agent. After switching, new chat messages are processed '
      'by the selected agent. Use agents_list to see available agent IDs.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'agent_id': {
            'type': 'string',
            'description': 'ID of the agent to switch to',
          },
        },
        'required': ['agent_id'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    final agentId = (arguments['agent_id'] as String?)?.trim() ?? '';
    if (agentId.isEmpty) {
      return ToolResult.error('agent_id is required');
    }

    final agent = configManager.config.agentProfiles
        .where((a) => a.id == agentId)
        .firstOrNull;
    if (agent == null) {
      return ToolResult.error(
          'Agent not found: $agentId. Use agents_list to see available agents.');
    }

    final currentId = configManager.config.activeAgentId ??
        configManager.config.activeAgent?.id;
    if (agentId == currentId) {
      return ToolResult.success(jsonEncode({
        'success': true,
        'agentId': agentId,
        'name': agent.name,
        'note': 'Agent "${agent.name}" is already active.',
      }));
    }

    try {
      await configManager.switchAgent(agentId);
      onConfigChanged();

      return ToolResult.success(jsonEncode({
        'success': true,
        'agentId': agentId,
        'name': agent.name,
        'emoji': agent.emoji,
        'sessionKey': 'webchat:$agentId',
        'note':
            'Switched to agent "${agent.name}" ${agent.emoji}. '
            'The next message will be processed by this agent.',
      }));
    } catch (e) {
      return ToolResult.error('Failed to switch agent: $e');
    }
  }
}
