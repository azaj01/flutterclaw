/// Config model for MCP server entries stored in FlutterClawConfig.
library;

import 'package:uuid/uuid.dart';

enum McpTransportType { http, sse, stdio }

enum McpConnectionStatus { disconnected, connecting, connected, error }

class McpServerEntry {
  final String id;
  final String name;
  final bool enabled;
  final McpTransportType transportType;

  // HTTP / SSE fields
  final String? baseUrl;
  final String? bearerToken;
  final Map<String, String>? headers;

  // Stdio fields
  final String? command;
  final List<String>? args;
  final Map<String, String>? env;

  const McpServerEntry({
    required this.id,
    required this.name,
    this.enabled = true,
    this.transportType = McpTransportType.http,
    this.baseUrl,
    this.bearerToken,
    this.headers,
    this.command,
    this.args,
    this.env,
  });

  /// Create a new HTTP/SSE entry with a fresh UUID.
  factory McpServerEntry.newHttp({
    required String name,
    required String baseUrl,
    String? bearerToken,
    Map<String, String>? headers,
    McpTransportType transportType = McpTransportType.http,
  }) =>
      McpServerEntry(
        id: const Uuid().v4(),
        name: name,
        transportType: transportType,
        baseUrl: baseUrl,
        bearerToken: bearerToken,
        headers: headers,
      );

  /// Create a new stdio entry with a fresh UUID.
  factory McpServerEntry.newStdio({
    required String name,
    required String command,
    List<String>? args,
    Map<String, String>? env,
  }) =>
      McpServerEntry(
        id: const Uuid().v4(),
        name: name,
        transportType: McpTransportType.stdio,
        command: command,
        args: args,
        env: env,
      );

  McpServerEntry copyWith({
    String? id,
    String? name,
    bool? enabled,
    McpTransportType? transportType,
    String? baseUrl,
    String? bearerToken,
    Map<String, String>? headers,
    String? command,
    List<String>? args,
    Map<String, String>? env,
  }) =>
      McpServerEntry(
        id: id ?? this.id,
        name: name ?? this.name,
        enabled: enabled ?? this.enabled,
        transportType: transportType ?? this.transportType,
        baseUrl: baseUrl ?? this.baseUrl,
        bearerToken: bearerToken ?? this.bearerToken,
        headers: headers ?? this.headers,
        command: command ?? this.command,
        args: args ?? this.args,
        env: env ?? this.env,
      );

  factory McpServerEntry.fromJson(Map<String, dynamic> json) {
    final transportStr = json['transport_type'] as String? ?? 'http';
    final transportType = McpTransportType.values.firstWhere(
      (t) => t.name == transportStr,
      orElse: () => McpTransportType.http,
    );

    final rawHeaders = json['headers'] as Map<String, dynamic>?;
    final rawEnv = json['env'] as Map<String, dynamic>?;
    final rawArgs = json['args'] as List<dynamic>?;

    return McpServerEntry(
      id: json['id'] as String,
      name: json['name'] as String,
      enabled: (json['enabled'] as bool?) ?? true,
      transportType: transportType,
      baseUrl: json['base_url'] as String?,
      bearerToken: json['bearer_token'] as String?,
      headers: rawHeaders?.map((k, v) => MapEntry(k, v as String)),
      command: json['command'] as String?,
      args: rawArgs?.map((e) => e as String).toList(),
      env: rawEnv?.map((k, v) => MapEntry(k, v as String)),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'enabled': enabled,
        'transport_type': transportType.name,
        if (baseUrl != null) 'base_url': baseUrl,
        if (bearerToken != null) 'bearer_token': bearerToken,
        if (headers != null && headers!.isNotEmpty) 'headers': headers,
        if (command != null) 'command': command,
        if (args != null && args!.isNotEmpty) 'args': args,
        if (env != null && env!.isNotEmpty) 'env': env,
      };
}
