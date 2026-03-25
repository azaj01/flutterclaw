/// McpClientManager — connection pool for MCP servers.
///
/// Manages connect/disconnect lifecycle, tool discovery, and tool execution.
/// When tools are discovered (or a server disconnects), the [onToolsChanged]
/// callback is fired so the ToolRegistry can be updated.
library;

import 'dart:async';

import 'package:logging/logging.dart';

import 'package:flutterclaw/data/models/mcp_server_config.dart';
import 'package:flutterclaw/services/mcp/mcp_client.dart';
import 'package:flutterclaw/services/mcp/mcp_protocol.dart';
import 'package:flutterclaw/services/mcp/mcp_transport.dart';
import 'package:flutterclaw/tools/registry.dart';

final _log = Logger('McpClientManager');

class McpClientManager {
  final Map<String, McpClient> _clients = {};
  final Map<String, McpServerEntry> _entries = {};
  final Map<String, McpConnectionStatus> _statuses = {};
  final Map<String, List<McpToolInfo>> _discoveredTools = {};

  /// Called when a server's tool list changes (connected or disconnected).
  /// [serverId] is the server's id; [tools] is empty on disconnect.
  void Function(String serverId, McpServerEntry entry, List<McpToolInfo> tools)?
      onToolsChanged;

  // ─── Public API ──────────────────────────────────────────────────────────────

  McpConnectionStatus getStatus(String serverId) =>
      _statuses[serverId] ?? McpConnectionStatus.disconnected;

  List<McpToolInfo> getDiscoveredTools(String serverId) =>
      _discoveredTools[serverId] ?? [];

  List<McpServerEntry> get entries => List.unmodifiable(_entries.values);

  /// Connect all enabled servers from a list of entries.
  Future<void> connectAll(List<McpServerEntry> servers) async {
    for (final server in servers) {
      if (server.enabled) {
        unawaited(_connectSafe(server));
      }
    }
  }

  /// Connect a single server. Safe to call even if already connected —
  /// existing connection is reused.
  Future<void> connectServer(McpServerEntry entry) async {
    if (_clients.containsKey(entry.id)) {
      _log.fine('Server ${entry.name} already connected, skipping');
      return;
    }
    await _connectSafe(entry);
  }

  /// Disconnect a server and remove its proxy tools.
  Future<void> disconnectServer(String serverId) async {
    final client = _clients.remove(serverId);
    final entry = _entries[serverId];
    _discoveredTools.remove(serverId);
    _statuses[serverId] = McpConnectionStatus.disconnected;

    await client?.close();

    if (entry != null) {
      onToolsChanged?.call(serverId, entry, []);
    }
  }

  /// Call a tool on the given server and return a ToolResult.
  Future<ToolResult> callTool(
    String serverId,
    String toolName,
    Map<String, dynamic> args,
  ) async {
    final client = _clients[serverId];
    if (client == null) {
      return ToolResult.error(
          'MCP server "$serverId" is not connected. Check settings.');
    }

    try {
      final result = await client.callTool(toolName, args);
      final text = result.toText();
      return result.isError
          ? ToolResult.error(text.isEmpty ? 'MCP tool returned an error' : text)
          : ToolResult.success(text.isEmpty ? '(no output)' : text);
    } on McpClientException catch (e) {
      // If the call fails with a transport error, reset the connection.
      _log.warning('Tool call failed, resetting connection: $e');
      await disconnectServer(serverId);
      return ToolResult.error('MCP tool call failed: $e');
    } catch (e) {
      return ToolResult.error('MCP tool call error: $e');
    }
  }

  /// Disconnect all servers.
  Future<void> disconnectAll() async {
    final ids = List<String>.from(_clients.keys);
    for (final id in ids) {
      await disconnectServer(id);
    }
  }

  // ─── Internal ─────────────────────────────────────────────────────────────

  Future<void> _connectSafe(McpServerEntry entry) async {
    _entries[entry.id] = entry;
    _statuses[entry.id] = McpConnectionStatus.connecting;
    _log.info('Connecting to MCP server "${entry.name}" (${entry.transportType.name})');

    try {
      final transport = _buildTransport(entry);
      final client = McpClient(transport);
      await client.initialize();

      _clients[entry.id] = client;
      _statuses[entry.id] = McpConnectionStatus.connected;
      _log.info('Connected to "${entry.name}"');

      final tools = await client.listTools();
      _discoveredTools[entry.id] = tools;
      _log.info('Discovered ${tools.length} tools from "${entry.name}"');

      onToolsChanged?.call(entry.id, entry, tools);
    } catch (e) {
      _log.warning('Failed to connect to "${entry.name}": $e');
      _statuses[entry.id] = McpConnectionStatus.error;
      _clients.remove(entry.id);
    }
  }

  McpTransport _buildTransport(McpServerEntry entry) {
    switch (entry.transportType) {
      case McpTransportType.http:
      case McpTransportType.sse:
        final url = entry.baseUrl;
        if (url == null || url.isEmpty) {
          throw McpTransportException(
              'baseUrl is required for HTTP/SSE transport');
        }
        final headers = <String, String>{
          if (entry.bearerToken != null && entry.bearerToken!.isNotEmpty)
            'Authorization': 'Bearer ${entry.bearerToken}',
          ...?entry.headers,
        };
        return HttpSseTransport(baseUrl: url, headers: headers);

      case McpTransportType.stdio:
        final command = entry.command;
        if (command == null || command.isEmpty) {
          throw McpTransportException(
              'command is required for stdio transport');
        }
        return StdioTransport(
          command: command,
          args: entry.args ?? [],
          env: entry.env ?? {},
        );
    }
  }
}
