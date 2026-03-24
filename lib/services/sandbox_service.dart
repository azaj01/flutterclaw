/// Dart bridge to the native Sandbox MethodChannel + EventChannel.
///
/// Provides typed wrappers for sandbox_status, sandbox_setup, sandbox_exec,
/// and sandbox_kill methods, plus execStream() via EventChannel. All methods return a
/// `Map<String, dynamic>` and never throw — PlatformExceptions are caught
/// and returned as `{'error': true, 'code': ..., 'message': ...}`.
library;

import 'package:flutter/services.dart';

class SandboxService {
  static const _channel = MethodChannel('ai.flutterclaw/sandbox');
  static const _streamChannel = EventChannel('ai.flutterclaw/sandbox_stream');

  /// Check whether the sandbox environment is ready.
  Future<Map<String, dynamic>> status() => _invoke('sandbox_status');

  /// Initialize the sandbox environment. Idempotent.
  Future<Map<String, dynamic>> setup() => _invoke('sandbox_setup');

  /// Execute a shell command (buffered — waits for completion).
  Future<Map<String, dynamic>> exec({
    required String command,
    int timeoutMs = 30000,
    String? workingDir,
  }) =>
      _invoke('sandbox_exec', {
        'command': command,
        'timeout_ms': timeoutMs,
        'working_dir': workingDir,
      });

  /// Execute a shell command with streaming output via EventChannel.
  ///
  /// Yields events as they arrive:
  ///   `{type: "stdout", data: "..."}` — stdout chunk
  ///   `{type: "stderr", data: "..."}` — stderr chunk
  ///   `{type: "exit", exit_code: int, timed_out: bool}` — process exited
  Stream<Map<String, dynamic>> execStream({
    required String command,
    int timeoutMs = 30000,
    String? workingDir,
  }) async* {
    // Pass command args via receiveBroadcastStream — this triggers
    // EventChannel.onListen on the native side with these args,
    // ensuring the eventSink is set BEFORE execution starts.
    await for (final event in _streamChannel.receiveBroadcastStream({
      'command': command,
      'timeout_ms': timeoutMs,
      'working_dir': workingDir,
    })) {
      if (event is Map) {
        yield Map<String, dynamic>.from(event);
      }
    }
  }

  /// Write raw data to the VM's stdin (for interactive terminal input).
  /// Only works when a VM session is active.
  Future<Map<String, dynamic>> writeStdin(String data) =>
      _invoke('sandbox_write_stdin', {'data': data});

  /// Kill the currently running sandbox process.
  Future<Map<String, dynamic>> kill() => _invoke('sandbox_kill');

  // ─── Internal ──────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> _invoke(
    String method, [
    Map<String, dynamic>? args,
  ]) async {
    try {
      final result = await _channel.invokeMapMethod<String, dynamic>(
        method,
        args,
      );
      return result ?? {};
    } on PlatformException catch (e) {
      return {
        'error': true,
        'code': e.code,
        'message': e.message ?? 'Unknown error',
      };
    }
  }
}
