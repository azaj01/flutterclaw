/// OpenClaw gateway protocol types.
///
/// Implements the framing and message structures for the OpenClaw
/// WebSocket gateway protocol.
library;

import 'dart:convert';

import 'package:logging/logging.dart';

final _log = Logger('flutterclaw.protocol');

// ---------------------------------------------------------------------------
// Frame types
// ---------------------------------------------------------------------------

/// Base protocol frame. All messages use one of: req, res, event.
class ProtocolFrame {
  final String type; // 'req' | 'res' | 'event'
  final String? id;
  final String? method;
  final Map<String, dynamic>? params;
  final String? event;
  final dynamic payload;
  final bool? ok;
  final Map<String, dynamic>? error;
  final int? seq;
  final int? stateVersion;

  const ProtocolFrame({
    required this.type,
    this.id,
    this.method,
    this.params,
    this.event,
    this.payload,
    this.ok,
    this.error,
    this.seq,
    this.stateVersion,
  });

  factory ProtocolFrame.fromJson(Map<String, dynamic> json) => ProtocolFrame(
        type: json['type'] as String,
        id: json['id'] as String?,
        method: json['method'] as String?,
        params: json['params'] as Map<String, dynamic>?,
        event: json['event'] as String?,
        payload: json['payload'],
        ok: json['ok'] as bool?,
        error: json['error'] as Map<String, dynamic>?,
        seq: json['seq'] as int?,
        stateVersion: json['stateVersion'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        if (id != null) 'id': id,
        if (method != null) 'method': method,
        if (params != null) 'params': params,
        if (event != null) 'event': event,
        if (payload != null) 'payload': payload,
        if (ok != null) 'ok': ok,
        if (error != null) 'error': error,
        if (seq != null) 'seq': seq,
        if (stateVersion != null) 'stateVersion': stateVersion,
      };

  String toJsonString() => jsonEncode(toJson());

  static ProtocolFrame? tryParse(String raw) {
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>?;
      if (json == null) return null;
      return ProtocolFrame.fromJson(json);
    } catch (e) {
      _log.warning('Failed to parse protocol frame: $e');
      return null;
    }
  }
}

// ---------------------------------------------------------------------------
// Connect handshake
// ---------------------------------------------------------------------------

/// Challenge sent by gateway before connect.
class ConnectChallenge {
  final String nonce;
  final int ts;

  const ConnectChallenge({required this.nonce, required this.ts});

  factory ConnectChallenge.fromJson(Map<String, dynamic> json) =>
      ConnectChallenge(
        nonce: json['nonce'] as String,
        ts: json['ts'] as int,
      );

  Map<String, dynamic> toJson() => {'nonce': nonce, 'ts': ts};
}

/// Client identity for connect params.
class ConnectClient {
  final String id;
  final String version;
  final String platform;
  final String mode; // 'operator' | 'node'

  const ConnectClient({
    required this.id,
    required this.version,
    required this.platform,
    required this.mode,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'version': version,
        'platform': platform,
        'mode': mode,
      };
}

/// Device identity for connect params.
class ConnectDevice {
  final String id;
  final String? publicKey;
  final String? signature;
  final int? signedAt;
  final String? nonce;

  const ConnectDevice({
    required this.id,
    this.publicKey,
    this.signature,
    this.signedAt,
    this.nonce,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        if (publicKey != null) 'publicKey': publicKey,
        if (signature != null) 'signature': signature,
        if (signedAt != null) 'signedAt': signedAt,
        if (nonce != null) 'nonce': nonce,
      };
}

/// Params for connect request.
class ConnectParams {
  final int minProtocol;
  final int maxProtocol;
  final ConnectClient client;
  final String role; // 'operator' | 'node'
  final List<String> scopes;
  final List<String> caps;
  final List<String> commands;
  final Map<String, dynamic> permissions;
  final Map<String, dynamic>? auth;
  final String? locale;
  final String? userAgent;
  final ConnectDevice? device;

  const ConnectParams({
    this.minProtocol = 3,
    this.maxProtocol = 3,
    required this.client,
    required this.role,
    this.scopes = const [],
    this.caps = const [],
    this.commands = const [],
    this.permissions = const {},
    this.auth,
    this.locale = 'en-US',
    this.userAgent,
    this.device,
  });

  Map<String, dynamic> toJson() => {
        'minProtocol': minProtocol,
        'maxProtocol': maxProtocol,
        'client': client.toJson(),
        'role': role,
        'scopes': scopes,
        'caps': caps,
        'commands': commands,
        'permissions': permissions,
        if (auth != null) 'auth': auth,
        if (locale != null) 'locale': locale,
        if (userAgent != null) 'userAgent': userAgent,
        if (device != null) 'device': device!.toJson(),
      };
}

/// Hello-ok payload from successful connect.
class HelloOk {
  final String type;
  final int protocol;
  final Map<String, dynamic>? policy;
  final HelloOkAuth? auth;

  const HelloOk({
    this.type = 'hello-ok',
    required this.protocol,
    this.policy,
    this.auth,
  });

  factory HelloOk.fromJson(Map<String, dynamic> json) => HelloOk(
        type: json['type'] as String? ?? 'hello-ok',
        protocol: json['protocol'] as int,
        policy: json['policy'] as Map<String, dynamic>?,
        auth: json['auth'] != null
            ? HelloOkAuth.fromJson(json['auth'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'protocol': protocol,
        if (policy != null) 'policy': policy,
        if (auth != null) 'auth': auth!.toJson(),
      };
}

class HelloOkAuth {
  final String? deviceToken;
  final String? role;
  final List<String>? scopes;

  const HelloOkAuth({
    this.deviceToken,
    this.role,
    this.scopes,
  });

  factory HelloOkAuth.fromJson(Map<String, dynamic> json) => HelloOkAuth(
        deviceToken: json['deviceToken'] as String?,
        role: json['role'] as String?,
        scopes: (json['scopes'] as List<dynamic>?)?.cast<String>(),
      );

  Map<String, dynamic> toJson() => {
        if (deviceToken != null) 'deviceToken': deviceToken,
        if (role != null) 'role': role,
        if (scopes != null) 'scopes': scopes,
      };
}

// ---------------------------------------------------------------------------
// Chat
// ---------------------------------------------------------------------------

/// Params for chat.send method.
class ChatSendParams {
  final String channelType;
  final String chatId;
  final String text;
  final String? sessionKey;

  const ChatSendParams({
    required this.channelType,
    required this.chatId,
    required this.text,
    this.sessionKey,
  });

  factory ChatSendParams.fromJson(Map<String, dynamic> json) => ChatSendParams(
        channelType: json['channelType'] as String,
        chatId: json['chatId'] as String,
        text: json['text'] as String,
        sessionKey: json['sessionKey'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'channelType': channelType,
        'chatId': chatId,
        'text': text,
        if (sessionKey != null) 'sessionKey': sessionKey,
      };
}

/// Result of chat.send.
class ChatSendResult {
  final String messageId;
  final String? sessionKey;

  const ChatSendResult({
    required this.messageId,
    this.sessionKey,
  });

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        if (sessionKey != null) 'sessionKey': sessionKey,
      };
}

// ---------------------------------------------------------------------------
// Sessions
// ---------------------------------------------------------------------------

/// Session summary for sessions.list.
class SessionSummary {
  final String key;
  final String channelType;
  final String chatId;
  final int messageCount;
  final int totalTokens;
  final DateTime lastActivity;
  final String? modelOverride;

  const SessionSummary({
    required this.key,
    required this.channelType,
    required this.chatId,
    required this.messageCount,
    required this.totalTokens,
    required this.lastActivity,
    this.modelOverride,
  });

  Map<String, dynamic> toJson() => {
        'key': key,
        'channelType': channelType,
        'chatId': chatId,
        'messageCount': messageCount,
        'totalTokens': totalTokens,
        'lastActivity': lastActivity.toIso8601String(),
        if (modelOverride != null) 'modelOverride': modelOverride,
      };
}

/// Params for sessions.history.
class SessionsHistoryParams {
  final String sessionKey;
  final int? limit;

  const SessionsHistoryParams({
    required this.sessionKey,
    this.limit,
  });

  factory SessionsHistoryParams.fromJson(Map<String, dynamic> json) =>
      SessionsHistoryParams(
        sessionKey: json['sessionKey'] as String,
        limit: json['limit'] as int?,
      );
}

// ---------------------------------------------------------------------------
// Tools
// ---------------------------------------------------------------------------

/// Tool definition for tools.catalog.
class ToolCatalogEntry {
  final String name;
  final String description;
  final Map<String, dynamic> parameters;
  final String? source; // 'core' | 'plugin'
  final String? pluginId;

  const ToolCatalogEntry({
    required this.name,
    required this.description,
    required this.parameters,
    this.source,
    this.pluginId,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'parameters': parameters,
        if (source != null) 'source': source,
        if (pluginId != null) 'pluginId': pluginId,
      };
}

/// Result of tools.catalog.
class ToolsCatalogResult {
  final List<ToolCatalogEntry> tools;

  const ToolsCatalogResult({required this.tools});

  Map<String, dynamic> toJson() => {
        'tools': tools.map((t) => t.toJson()).toList(),
      };
}

// ---------------------------------------------------------------------------
// Status
// ---------------------------------------------------------------------------

/// Status result.
class StatusResult {
  final String state; // 'idle' | 'busy' | 'starting' | 'stopping'
  final String? currentSessionKey;
  final int activeConnections;

  const StatusResult({
    this.state = 'idle',
    this.currentSessionKey,
    this.activeConnections = 0,
  });

  Map<String, dynamic> toJson() => {
        'state': state,
        if (currentSessionKey != null) 'currentSessionKey': currentSessionKey,
        'activeConnections': activeConnections,
      };
}
