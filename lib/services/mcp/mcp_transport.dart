/// MCP transport layer: abstract interface + HTTP/SSE + Stdio implementations.
///
/// HTTP/SSE (StreamableHTTP) works on both iOS and Android.
/// Stdio works on Android only (spawns a subprocess).
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'mcp_protocol.dart';

final _log = Logger('McpTransport');

// ─── Abstract transport ───────────────────────────────────────────────────────

abstract class McpTransport {
  /// Open the connection. Must be called before [sendRequest].
  Future<void> connect();

  /// Send a JSON-RPC request and wait for the response.
  Future<JsonRpcResponse> sendRequest(JsonRpcRequest request,
      {Duration timeout = const Duration(seconds: 30)});

  /// Send a JSON-RPC notification (no response expected).
  Future<void> sendNotification(JsonRpcNotification notification);

  /// Incoming server-pushed notifications.
  Stream<JsonRpcNotification> get notifications;

  /// Close the connection and release resources.
  Future<void> close();

  bool get isConnected;
}

// ─── HTTP / StreamableHTTP + SSE transport ────────────────────────────────────

/// Connects to MCP servers that speak HTTP.
///
/// Protocol negotiation (from mcporter pattern):
/// 1. POST initialize to baseUrl — if server returns SSE content-type,
///    switch to SSE mode (old-style servers).
/// 2. Otherwise assume StreamableHTTP: each POST returns a JSON-RPC response.
/// 3. For notifications, open a long-lived GET /sse endpoint if available.
class HttpSseTransport extends McpTransport {
  final String baseUrl;
  final Map<String, String> headers;
  final Dio _dio;

  bool _connected = false;
  bool _sseMode = false; // true = old SSE mode, false = StreamableHTTP

  // Pending request completers keyed by request id.
  final Map<int, Completer<JsonRpcResponse>> _pending = {};

  // Notification controller.
  final StreamController<JsonRpcNotification> _notificationsCtrl =
      StreamController.broadcast();

  // SSE mode: background subscription.
  StreamSubscription<String>? _sseSub;

  HttpSseTransport({
    required this.baseUrl,
    this.headers = const {},
    Dio? dio,
  }) : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 30),
            ));

  @override
  bool get isConnected => _connected;

  @override
  Stream<JsonRpcNotification> get notifications => _notificationsCtrl.stream;

  @override
  Future<void> connect() async {
    // We detect mode lazily on first request (initialize).
    // Mark as connected so sendRequest works.
    _connected = true;
  }

  @override
  Future<JsonRpcResponse> sendRequest(
    JsonRpcRequest request, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (_sseMode) {
      return _sendSse(request, timeout: timeout);
    }
    return _sendStreamableHttp(request, timeout: timeout);
  }

  Future<JsonRpcResponse> _sendStreamableHttp(
    JsonRpcRequest request, {
    required Duration timeout,
  }) async {
    final allHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json, text/event-stream',
      ...headers,
    };

    try {
      final response = await _dio
          .post<dynamic>(
            baseUrl,
            data: request.toJson(),
            options: Options(
              headers: allHeaders,
              receiveTimeout: timeout,
              validateStatus: (_) => true,
            ),
          )
          .timeout(timeout);

      final contentType =
          (response.headers.value('content-type') ?? '').toLowerCase();

      if (contentType.contains('text/event-stream')) {
        // Server only speaks SSE — switch modes and re-send.
        _log.info('Server at $baseUrl returned SSE. Switching to SSE mode.');
        _sseMode = true;
        await _startSseListener();
        return _sendSse(request, timeout: timeout);
      }

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw McpTransportException(
            'Authentication failed (${response.statusCode}). '
            'Check the bearer token for this MCP server.');
      }
      if (response.statusCode != null && response.statusCode! >= 400) {
        throw McpTransportException(
            'HTTP ${response.statusCode} from MCP server at $baseUrl');
      }

      final body = response.data;
      if (body == null) {
        throw McpTransportException('Empty response from MCP server');
      }
      final json =
          body is Map ? body as Map<String, dynamic> : jsonDecode(body as String) as Map<String, dynamic>;
      return JsonRpcResponse.fromJson(json);
    } on DioException catch (e) {
      throw McpTransportException('HTTP request failed: ${e.message}');
    }
  }

  /// Start SSE listener on the /sse endpoint (old-style MCP servers).
  Future<void> _startSseListener() async {
    final sseUrl =
        baseUrl.endsWith('/') ? '${baseUrl}sse' : '$baseUrl/sse';
    final allHeaders = {
      'Accept': 'text/event-stream',
      'Cache-Control': 'no-cache',
      ...headers,
    };

    final client = HttpClient();
    final request = await client.getUrl(Uri.parse(sseUrl));
    allHeaders.forEach((k, v) => request.headers.set(k, v));
    final httpResponse = await request.close();

    final lineStream = httpResponse
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    _sseSub = _parseSseLines(lineStream).listen((rawData) {
      try {
        final msg = parseMcpMessage(rawData);
        if (msg is McpResponseMessage) {
          final completer = _pending.remove(msg.response.id);
          completer?.complete(msg.response);
        } else if (msg is McpNotificationMessage) {
          _notificationsCtrl.add(msg.notification);
        }
      } catch (e) {
        _log.warning('Failed to parse SSE message: $e');
      }
    });
  }

  /// In SSE mode, POST the JSON-RPC request to the server and await the
  /// response that will come back over the SSE stream.
  Future<JsonRpcResponse> _sendSse(
    JsonRpcRequest request, {
    required Duration timeout,
  }) async {
    final completer = Completer<JsonRpcResponse>();
    _pending[request.id] = completer;

    final postUrl =
        baseUrl.endsWith('/') ? '${baseUrl}messages' : '$baseUrl/messages';
    final allHeaders = {
      'Content-Type': 'application/json',
      ...headers,
    };

    try {
      await _dio.post<dynamic>(
        postUrl,
        data: request.toJson(),
        options: Options(headers: allHeaders, validateStatus: (_) => true),
      );
    } catch (e) {
      _pending.remove(request.id);
      completer.completeError(McpTransportException('SSE POST failed: $e'));
    }

    return completer.future.timeout(timeout, onTimeout: () {
      _pending.remove(request.id);
      throw McpTransportException(
          'Timeout waiting for SSE response to request ${request.id}');
    });
  }

  @override
  Future<void> sendNotification(JsonRpcNotification notification) async {
    if (_sseMode) {
      final postUrl = baseUrl.endsWith('/')
          ? '${baseUrl}messages'
          : '$baseUrl/messages';
      await _dio.post<dynamic>(
        postUrl,
        data: notification.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json', ...headers},
          validateStatus: (_) => true,
        ),
      );
    } else {
      await _dio.post<dynamic>(
        baseUrl,
        data: notification.toJson(),
        options: Options(
          headers: {'Content-Type': 'application/json', ...headers},
          validateStatus: (_) => true,
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    _connected = false;
    await _sseSub?.cancel();
    _notificationsCtrl.close();
    for (final c in _pending.values) {
      c.completeError(McpTransportException('Transport closed'));
    }
    _pending.clear();
  }
}

// ─── Stdio transport ──────────────────────────────────────────────────────────

/// Connects to MCP servers that communicate over stdin/stdout.
/// Only available on Android (and desktop). Not supported on iOS.
class StdioTransport extends McpTransport {
  final String command;
  final List<String> args;
  final Map<String, String> env;

  Process? _process;
  bool _connected = false;

  final Map<int, Completer<JsonRpcResponse>> _pending = {};
  final StreamController<JsonRpcNotification> _notificationsCtrl =
      StreamController.broadcast();
  StreamSubscription<String>? _stdoutSub;

  StdioTransport({
    required this.command,
    this.args = const [],
    this.env = const {},
  });

  @override
  bool get isConnected => _connected;

  @override
  Stream<JsonRpcNotification> get notifications => _notificationsCtrl.stream;

  @override
  Future<void> connect() async {
    if (Platform.isIOS) {
      throw McpTransportException(
          'Stdio transport is not available on iOS. Use HTTP/SSE instead.');
    }
    final mergedEnv = {...Platform.environment, ...env};
    _process = await Process.start(
      command,
      args,
      environment: mergedEnv,
      runInShell: false,
    );

    _stdoutSub = _process!.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(_handleLine, onError: (Object e) {
      _log.warning('Stdio stdout error: $e');
    });

    _process!.stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) => _log.fine('MCP stderr: $line'));

    _connected = true;
  }

  void _handleLine(String line) {
    if (line.trim().isEmpty) return;
    try {
      final msg = parseMcpMessage(line);
      if (msg is McpResponseMessage) {
        final completer = _pending.remove(msg.response.id);
        completer?.complete(msg.response);
      } else if (msg is McpNotificationMessage) {
        _notificationsCtrl.add(msg.notification);
      }
    } catch (e) {
      _log.warning('Failed to parse stdio line: $e\nLine: $line');
    }
  }

  @override
  Future<JsonRpcResponse> sendRequest(
    JsonRpcRequest request, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final completer = Completer<JsonRpcResponse>();
    _pending[request.id] = completer;
    _process!.stdin.writeln(request.toJsonString());
    return completer.future.timeout(timeout, onTimeout: () {
      _pending.remove(request.id);
      throw McpTransportException(
          'Timeout waiting for stdio response to request ${request.id}');
    });
  }

  @override
  Future<void> sendNotification(JsonRpcNotification notification) async {
    _process!.stdin.writeln(notification.toJsonString());
  }

  @override
  Future<void> close() async {
    _connected = false;
    await _stdoutSub?.cancel();
    _process?.stdin.close();
    _process?.kill();
    _process = null;
    _notificationsCtrl.close();
    for (final c in _pending.values) {
      c.completeError(McpTransportException('Transport closed'));
    }
    _pending.clear();
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class McpTransportException implements Exception {
  final String message;
  McpTransportException(this.message);

  @override
  String toString() => 'McpTransportException: $message';
}

/// Parse an SSE line stream into data payloads.
/// SSE format: "data: {...}\n\n"
Stream<String> _parseSseLines(Stream<String> lines) async* {
  await for (final line in lines) {
    if (line.startsWith('data: ')) {
      yield line.substring(6);
    }
  }
}
