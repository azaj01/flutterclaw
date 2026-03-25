/// MCP (Model Context Protocol) JSON-RPC 2.0 message types.
///
/// The MCP protocol uses JSON-RPC 2.0 over stdio or HTTP/SSE transports.
/// We implement the subset needed for tool discovery and execution:
/// initialize, notifications/initialized, tools/list, tools/call.
library;

import 'dart:convert';

// ─── JSON-RPC 2.0 base types ──────────────────────────────────────────────────

class JsonRpcRequest {
  static int _nextId = 1;

  final int id;
  final String method;
  final Map<String, dynamic>? params;

  JsonRpcRequest({required this.method, this.params}) : id = _nextId++;

  Map<String, dynamic> toJson() => {
        'jsonrpc': '2.0',
        'id': id,
        'method': method,
        if (params != null) 'params': params,
      };

  String toJsonString() => jsonEncode(toJson());
}

class JsonRpcNotification {
  final String method;
  final Map<String, dynamic>? params;

  const JsonRpcNotification({required this.method, this.params});

  Map<String, dynamic> toJson() => {
        'jsonrpc': '2.0',
        'method': method,
        if (params != null) 'params': params,
      };

  String toJsonString() => jsonEncode(toJson());
}

class JsonRpcError {
  final int code;
  final String message;
  final dynamic data;

  const JsonRpcError({required this.code, required this.message, this.data});

  factory JsonRpcError.fromJson(Map<String, dynamic> json) => JsonRpcError(
        code: json['code'] as int,
        message: json['message'] as String,
        data: json['data'],
      );

  @override
  String toString() => 'JsonRpcError($code): $message';
}

class JsonRpcResponse {
  final int? id;
  final dynamic result;
  final JsonRpcError? error;

  const JsonRpcResponse({this.id, this.result, this.error});

  bool get isError => error != null;

  factory JsonRpcResponse.fromJson(Map<String, dynamic> json) {
    final errorJson = json['error'];
    return JsonRpcResponse(
      id: json['id'] as int?,
      result: json['result'],
      error: errorJson != null
          ? JsonRpcError.fromJson(errorJson as Map<String, dynamic>)
          : null,
    );
  }
}

// ─── MCP-specific types ───────────────────────────────────────────────────────

/// Info about a single tool exposed by an MCP server.
class McpToolInfo {
  final String name;
  final String description;
  final Map<String, dynamic> inputSchema;

  const McpToolInfo({
    required this.name,
    required this.description,
    required this.inputSchema,
  });

  factory McpToolInfo.fromJson(Map<String, dynamic> json) => McpToolInfo(
        name: json['name'] as String,
        description: (json['description'] as String?) ?? '',
        inputSchema: (json['inputSchema'] as Map<String, dynamic>?) ??
            {'type': 'object', 'properties': {}},
      );
}

/// A single content block in an MCP tool result.
class McpContentBlock {
  final String type; // 'text' | 'image' | 'resource'
  final String? text;
  final String? data; // base64 for images
  final String? mimeType;

  const McpContentBlock({
    required this.type,
    this.text,
    this.data,
    this.mimeType,
  });

  factory McpContentBlock.fromJson(Map<String, dynamic> json) =>
      McpContentBlock(
        type: json['type'] as String,
        text: json['text'] as String?,
        data: json['data'] as String?,
        mimeType: json['mimeType'] as String?,
      );
}

/// Result of calling an MCP tool.
class McpToolResult {
  final List<McpContentBlock> content;
  final bool isError;

  const McpToolResult({required this.content, this.isError = false});

  factory McpToolResult.fromJson(Map<String, dynamic> json) {
    final contentList = (json['content'] as List<dynamic>?) ?? [];
    return McpToolResult(
      content: contentList
          .map((c) => McpContentBlock.fromJson(c as Map<String, dynamic>))
          .toList(),
      isError: (json['isError'] as bool?) ?? false,
    );
  }

  /// Flatten all content blocks to a single string for the LLM.
  String toText() {
    final parts = <String>[];
    for (final block in content) {
      switch (block.type) {
        case 'text':
          if (block.text != null) parts.add(block.text!);
        case 'image':
          parts.add('[Image: ${block.mimeType ?? "unknown"}, base64 encoded]');
        case 'resource':
          if (block.text != null) parts.add(block.text!);
        default:
          if (block.text != null) parts.add(block.text!);
      }
    }
    return parts.join('\n');
  }
}

// ─── Incoming message parsing ─────────────────────────────────────────────────

/// Parse a raw JSON string from the transport into a response or notification.
sealed class McpIncomingMessage {}

class McpResponseMessage extends McpIncomingMessage {
  final JsonRpcResponse response;
  McpResponseMessage(this.response);
}

class McpNotificationMessage extends McpIncomingMessage {
  final JsonRpcNotification notification;
  McpNotificationMessage(this.notification);
}

McpIncomingMessage parseMcpMessage(String raw) {
  final json = jsonDecode(raw) as Map<String, dynamic>;
  if (json.containsKey('id') && !json.containsKey('method')) {
    return McpResponseMessage(JsonRpcResponse.fromJson(json));
  }
  return McpNotificationMessage(
    JsonRpcNotification(
      method: json['method'] as String,
      params: json['params'] as Map<String, dynamic>?,
    ),
  );
}
