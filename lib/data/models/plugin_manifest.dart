/// Plugin manifest model — corresponds to the plugin.json file in a plugin
/// directory. Modelled after OpenClaw's plugin format so ClawHub-compatible
/// plugins can be used on FlutterClaw with minimal adaptation.
library;

/// The types of artifacts a plugin can contribute.
enum PluginArtifactType { skill, hook, command, mcpConfig }

/// A single artifact entry inside a plugin manifest.
class PluginArtifact {
  /// Type of this artifact.
  final PluginArtifactType type;

  /// Path to the artifact file relative to the plugin root directory.
  final String path;

  /// Human-readable name for this artifact.
  final String? name;

  /// Short description shown in the UI.
  final String? description;

  const PluginArtifact({
    required this.type,
    required this.path,
    this.name,
    this.description,
  });

  factory PluginArtifact.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String? ?? 'skill';
    final type = switch (typeStr) {
      'hook' => PluginArtifactType.hook,
      'command' => PluginArtifactType.command,
      'mcp_config' => PluginArtifactType.mcpConfig,
      _ => PluginArtifactType.skill,
    };
    return PluginArtifact(
      type: type,
      path: json['path'] as String? ?? '',
      name: json['name'] as String?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': switch (type) {
          PluginArtifactType.hook => 'hook',
          PluginArtifactType.command => 'command',
          PluginArtifactType.mcpConfig => 'mcp_config',
          PluginArtifactType.skill => 'skill',
        },
        'path': path,
        if (name != null) 'name': name,
        if (description != null) 'description': description,
      };
}

/// Parsed representation of a plugin.json manifest file.
class PluginManifest {
  /// Unique plugin identifier (e.g. "security-guidance").
  final String id;

  /// Display name shown in the plugin list.
  final String name;

  /// Plugin version string.
  final String version;

  /// Short description of what the plugin does.
  final String description;

  /// Plugin author or organisation.
  final String? author;

  /// Repository or homepage URL.
  final String? url;

  /// Minimum FlutterClaw version required.
  final String? minVersion;

  /// All artifacts contributed by this plugin.
  final List<PluginArtifact> artifacts;

  /// Whether this plugin is currently enabled.
  bool enabled;

  /// Absolute path to the plugin's root directory on disk.
  String? installedPath;

  PluginManifest({
    required this.id,
    required this.name,
    required this.version,
    required this.description,
    this.author,
    this.url,
    this.minVersion,
    required this.artifacts,
    this.enabled = true,
    this.installedPath,
  });

  factory PluginManifest.fromJson(Map<String, dynamic> json) {
    final rawArtifacts = json['artifacts'] as List<dynamic>? ?? [];
    return PluginManifest(
      id: json['id'] as String? ?? json['name'] as String? ?? 'unknown',
      name: json['name'] as String? ?? json['id'] as String? ?? 'Unknown',
      version: json['version'] as String? ?? '0.0.0',
      description: json['description'] as String? ?? '',
      author: json['author'] as String?,
      url: json['url'] as String?,
      minVersion: json['minVersion'] as String?,
      artifacts: rawArtifacts
          .map((a) => PluginArtifact.fromJson(a as Map<String, dynamic>))
          .toList(),
      enabled: json['enabled'] as bool? ?? true,
      installedPath: json['installedPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'version': version,
        'description': description,
        if (author != null) 'author': author,
        if (url != null) 'url': url,
        if (minVersion != null) 'minVersion': minVersion,
        'artifacts': artifacts.map((a) => a.toJson()).toList(),
        'enabled': enabled,
        if (installedPath != null) 'installedPath': installedPath,
      };

  /// Convenience: all skill artifacts.
  List<PluginArtifact> get skills =>
      artifacts.where((a) => a.type == PluginArtifactType.skill).toList();

  /// Convenience: all hook artifacts.
  List<PluginArtifact> get hooks =>
      artifacts.where((a) => a.type == PluginArtifactType.hook).toList();

  /// Convenience: all command artifacts.
  List<PluginArtifact> get commands =>
      artifacts.where((a) => a.type == PluginArtifactType.command).toList();

  /// Convenience: all MCP config artifacts.
  List<PluginArtifact> get mcpConfigs =>
      artifacts.where((a) => a.type == PluginArtifactType.mcpConfig).toList();
}
