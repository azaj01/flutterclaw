/// MCP client: handles the protocol handshake and exposes
/// listTools / callTool over any McpTransport.
library;

import 'package:logging/logging.dart';

import 'mcp_protocol.dart';
import 'mcp_transport.dart';

final _log = Logger('McpClient');

class McpClient {
  final McpTransport transport;
  bool _initialized = false;

  McpClient(this.transport);

  bool get isConnected => transport.isConnected && _initialized;

  /// Connect transport and perform MCP initialize handshake.
  Future<void> initialize() async {
    await transport.connect();

    final req = JsonRpcRequest(
      method: 'initialize',
      params: {
        'protocolVersion': '2025-03-26',
        'capabilities': {
          'tools': {},
        },
        'clientInfo': {
          'name': 'FlutterClaw',
          'version': '1.0',
        },
      },
    );

    final response = await transport.sendRequest(req);
    if (response.isError) {
      throw McpClientException(
          'initialize failed: ${response.error}');
    }

    _log.fine('MCP initialize OK: ${response.result}');

    // Notify server that client is ready.
    await transport.sendNotification(
      JsonRpcNotification(method: 'notifications/initialized'),
    );

    _initialized = true;
  }

  /// List all tools available on this MCP server.
  /// Handles pagination via cursor automatically.
  Future<List<McpToolInfo>> listTools() async {
    _assertInitialized();
    final tools = <McpToolInfo>[];
    String? cursor;

    do {
      final params = <String, dynamic>{};
      if (cursor != null) params['cursor'] = cursor;

      final req = JsonRpcRequest(method: 'tools/list', params: params);
      final response = await transport.sendRequest(req);

      if (response.isError) {
        throw McpClientException('tools/list failed: ${response.error}');
      }

      final result = response.result as Map<String, dynamic>;
      final toolList = (result['tools'] as List<dynamic>?) ?? [];
      for (final t in toolList) {
        tools.add(McpToolInfo.fromJson(t as Map<String, dynamic>));
      }

      cursor = result['nextCursor'] as String?;
    } while (cursor != null);

    return tools;
  }

  /// Call a tool on this MCP server with the given arguments.
  Future<McpToolResult> callTool(
    String name,
    Map<String, dynamic> arguments,
  ) async {
    _assertInitialized();

    final req = JsonRpcRequest(
      method: 'tools/call',
      params: {
        'name': name,
        'arguments': arguments,
      },
    );

    final response = await transport.sendRequest(req,
        timeout: const Duration(seconds: 60));

    if (response.isError) {
      throw McpClientException('tools/call "$name" failed: ${response.error}');
    }

    return McpToolResult.fromJson(
        response.result as Map<String, dynamic>);
  }

  /// Close the transport.
  Future<void> close() async {
    _initialized = false;
    await transport.close();
  }

  void _assertInitialized() {
    if (!_initialized) {
      throw McpClientException(
          'McpClient not initialized. Call initialize() first.');
    }
  }
}

class McpClientException implements Exception {
  final String message;
  McpClientException(this.message);

  @override
  String toString() => 'McpClientException: $message';
}
