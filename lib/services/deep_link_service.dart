import 'dart:async';

import 'package:flutter/services.dart';

/// Parsed representation of a flutterclaw://callback deep link.
class DeepLinkCallback {
  final String runId;
  final String status; // 'success' | 'error' | 'cancelled' | 'timeout'
  final String? result;
  final String rawUrl;

  const DeepLinkCallback({
    required this.runId,
    required this.status,
    this.result,
    required this.rawUrl,
  });
}

/// Listens on the native MethodChannel 'ai.flutterclaw/deeplinks' and
/// re-emits parsed [DeepLinkCallback] events as a broadcast stream.
///
/// Call [init] once at app startup. Subsequent calls are no-ops.
class DeepLinkService {
  static const _channel = MethodChannel('ai.flutterclaw/deeplinks');

  final _controller = StreamController<DeepLinkCallback>.broadcast();

  Stream<DeepLinkCallback> get callbacks => _controller.stream;

  bool _initialized = false;

  void init() {
    if (_initialized) return;
    _initialized = true;

    _channel.setMethodCallHandler((call) async {
      if (call.method != 'onDeepLink') return;
      final rawUrl = call.arguments as String?;
      if (rawUrl == null || rawUrl.isEmpty) return;
      _handleRawUrl(rawUrl);
    });
  }

  void _handleRawUrl(String rawUrl) {
    try {
      final uri = Uri.parse(rawUrl);
      if (uri.host != 'callback') return;

      final runId = uri.queryParameters['runId'] ?? '';
      if (runId.isEmpty) return;

      _controller.add(DeepLinkCallback(
        runId: runId,
        status: uri.queryParameters['status'] ?? 'success',
        result: uri.queryParameters['result'],
        rawUrl: rawUrl,
      ));
    } catch (_) {
      // Malformed URL — ignore silently
    }
  }

  void dispose() => _controller.close();
}
