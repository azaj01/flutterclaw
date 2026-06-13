/// Background execution service using flutter_foreground_task.
///
/// Manages the foreground service (Android) and background modes (iOS).
/// Starts/stops the gateway+agent+channels in a foreground service isolate.
library;

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutterclaw/core/runtime/isolate_runtime.dart';
import 'package:flutterclaw/services/ios_background_audio_service.dart';
import 'package:flutterclaw/services/live_activity_service.dart';
import 'package:logging/logging.dart';

final _log = Logger('flutterclaw.background_service');

/// Top-level callback for the foreground task.
@pragma('vm:entry-point')
void startFlutterClawTask() {
  FlutterForegroundTask.setTaskHandler(FlutterClawTaskHandler());
}

/// Task handler that runs in the foreground service isolate.
class FlutterClawTaskHandler extends TaskHandler {
  IsolateRuntime? _runtime;
  bool _running = false;
  DateTime? _startedAt;
  String _gatewayState = 'stopped';
  String? _lastError;
  int _consecutiveFailures = 0;
  bool _isRetrying = false;
  String _host = '127.0.0.1';
  int _port = 18789;
  String _model = '';

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    _log.info('FlutterClawTaskHandler onStart (starter: ${starter.name})');
    _running = true;
    _startedAt = DateTime.now();

    if (Platform.isIOS) {
      final audioStarted = await IosBackgroundAudioService.start();
      if (!audioStarted) {
        _log.warning('iOS background audio failed to start (non-fatal)');
      }
    }

    _gatewayState = 'starting';
    _sendNotificationToMain('FlutterClaw', 'Starting... $_host:$_port');

    try {
      _runtime = await IsolateRuntime.bootstrap();
      _host = _runtime!.configManager.config.gateway.host;
      _port = _runtime!.configManager.config.gateway.port;
      _model = _runtime!.configManager.config.activeAgent?.modelName ??
          _runtime!.configManager.config.agents.defaults.modelName;
      _gatewayState = 'running';
      _lastError = null;
      _consecutiveFailures = 0;
      _refreshNotification();
      await LiveActivityService.startActivity(
        host: _host,
        port: _port,
        model: _model,
      );
      await Future.delayed(const Duration(milliseconds: 800));
      _refreshNotification();
    } catch (e, st) {
      _gatewayState = 'error';
      _lastError = e.toString();
      _log.warning('IsolateRuntime bootstrap failed', e, st);
      _sendNotificationToMain('Gateway error', _buildNotificationText());
      await LiveActivityService.startActivityWithError(
        host: _host,
        port: _port,
        model: _model,
        errorMessage: _lastError ?? 'Failed to start gateway',
      );
    }
  }

  static const MethodChannel _notificationUpdateChannel =
      MethodChannel('ai.flutterclaw/notification_update');

  void _sendNotificationToMain(String title, String text) {
    if (!Platform.isAndroid) {
      FlutterForegroundTask.updateService(
        notificationTitle: title,
        notificationText: text,
        notificationIcon: BackgroundService.notificationIcon,
        notificationButtons: BackgroundService.notificationButtons,
      );
      return;
    }
    try {
      _notificationUpdateChannel.invokeMethod<void>('update', {
        'notificationContentTitle': title,
        'notificationContentText': text,
      });
    } catch (e) {
      _log.warning('Failed to update notification via channel: $e');
    }
  }

  void _refreshNotification() {
    final sessionCount = _runtime != null
        ? _runtime!.sessionManager.listSessions().length
        : 0;
    final tokensProcessed = _runtime != null
        ? _runtime!.sessionManager
            .listSessions()
            .fold<int>(0, (sum, s) => sum + s.totalTokens)
        : 0;
    final title = _gatewayState == 'running'
        ? 'Gateway active'
        : _gatewayState == 'error'
            ? 'Gateway error'
            : 'Gateway stopped';
    _sendNotificationToMain(title, _buildNotificationText(
      sessionCount: sessionCount,
      tokensProcessed: tokensProcessed,
    ));
  }

  String _buildNotificationText({
    int? sessionCount,
    int? tokensProcessed,
  }) {
    final uptime = _startedAt != null
        ? DateTime.now().difference(_startedAt!).inSeconds
        : 0;
    final addr = '$_host:$_port';
    final modelLabel = _model.isNotEmpty ? _model : 'no model';

    switch (_gatewayState) {
      case 'running':
        final line1 =
            '\u25CF $modelLabel  \u00B7  $addr  \u00B7  ${_formatUptime(uptime)}';
        final lines = <String>[line1];
        if (sessionCount != null && tokensProcessed != null) {
          lines.add('$sessionCount chats  \u00B7  ${_formatTokens(tokensProcessed)} tokens');
        }
        return lines.join('\n');
      case 'starting':
        return '\u25CB Starting...  \u00B7  $addr';
      case 'error':
        final err = _lastError ?? 'Unknown error';
        final short = err.length > 60 ? '${err.substring(0, 60)}...' : err;
        return '\u26A0 $short';
      default:
        return _gatewayState;
    }
  }


  @override
  void onRepeatEvent(DateTime timestamp) {
    if (!_running) return;
    final uptime = _startedAt != null
        ? DateTime.now().difference(_startedAt!).inSeconds
        : 0;

    if (_runtime != null) {
      final isHealthy = _runtime!.gateway.isHealthy();
      if (isHealthy) {
        _consecutiveFailures = 0;
        _gatewayState = 'running';
        _refreshNotification();
        final sessions = _runtime!.sessionManager.listSessions();
        LiveActivityService.updateActivity(
          isRunning: true,
          status: 'running',
          tokensProcessed: sessions.fold(0, (sum, s) => sum + s.totalTokens),
          model: _model,
          sessionCount: sessions.length,
          uptimeSeconds: uptime,
        );
      } else {
        _consecutiveFailures++;
        if (_consecutiveFailures >= 3 && !_isRetrying) {
          _attemptGatewayRestart();
        }
      }
    }
  }

  void _attemptGatewayRestart() async {
    if (_isRetrying) return;
    _isRetrying = true;
    _gatewayState = 'restarting';
    try {
      await _runtime?.stop();
    } catch (_) {}
    _runtime = null;
    try {
      _runtime = await IsolateRuntime.bootstrap();
      _gatewayState = 'running';
      _lastError = null;
      _startedAt = DateTime.now();
    } catch (e) {
      _gatewayState = 'error';
      _lastError = e.toString();
    } finally {
      _isRetrying = false;
      _refreshNotification();
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    _log.info('FlutterClawTaskHandler onDestroy (isTimeout: $isTimeout)');
    _running = false;
    if (Platform.isIOS) {
      await IosBackgroundAudioService.stop();
    }
    await LiveActivityService.endActivity();
    await _runtime?.stop();
    _runtime = null;
  }

  @override
  void onReceiveData(Object data) {}

  @override
  void onNotificationButtonPressed(String id) {
    if (id == 'stop') {
      FlutterForegroundTask.stopService();
    }
  }

  @override
  void onNotificationPressed() {}

  @override
  void onNotificationDismissed() {}
}

String _formatUptime(int seconds) {
  if (seconds < 60) return '${seconds}s';
  if (seconds < 3600) return '${seconds ~/ 60}m ${seconds % 60}s';
  return '${seconds ~/ 3600}h ${(seconds % 3600) ~/ 60}m';
}

String _formatTokens(int n) {
  if (n < 1000) return '$n';
  return '${(n / 1000).toStringAsFixed(1)}k';
}

/// Service for managing the foreground task lifecycle.
class BackgroundService {
  static bool _initialized = false;

  static const notificationIcon = NotificationIcon(
    metaDataName: 'com.flutterclaw.notification_icon',
  );
  static const notificationButtons = [
    NotificationButton(id: 'open', text: 'Open'),
    NotificationButton(id: 'stop', text: 'Stop'),
  ];

  static Future<void> initializeService() async {
    if (_initialized) return;
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'flutterclaw_foreground',
        channelName: 'FlutterClaw Gateway',
        channelDescription: 'AI gateway running status',
        channelImportance: NotificationChannelImportance.DEFAULT,
        priority: NotificationPriority.DEFAULT,
        visibility: NotificationVisibility.VISIBILITY_PUBLIC,
        onlyAlertOnce: true,
        showWhen: false,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: true,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: false,
      ),
    );
    _initialized = true;
    _log.info('BackgroundService initialized');
  }

  static Future<ServiceRequestResult> startService() async {
    if (!_initialized) {
      await initializeService();
    }
    return FlutterForegroundTask.startService(
      notificationTitle: 'FlutterClaw',
      notificationText: 'Starting gateway...',
      notificationIcon: notificationIcon,
      notificationButtons: notificationButtons,
      callback: startFlutterClawTask,
    );
  }

  static Future<ServiceRequestResult> stopService() async {
    return FlutterForegroundTask.stopService();
  }
}
