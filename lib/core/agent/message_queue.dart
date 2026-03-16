/// Per-session message queue matching OpenClaw's lane-based serialization.
///
/// Ensures only one agent run executes per session at a time.
/// Queued messages are coalesced into the next turn (collect mode).
library;

import 'dart:async';
import 'dart:collection';

import 'package:logging/logging.dart';

final _log = Logger('flutterclaw.message_queue');

class QueuedMessage {
  final String sessionKey;
  final String text;
  final String channelType;
  final String chatId;
  final DateTime queuedAt;

  QueuedMessage({
    required this.sessionKey,
    required this.text,
    required this.channelType,
    required this.chatId,
  }) : queuedAt = DateTime.now();
}

typedef RunHandler = Future<void> Function(
  String sessionKey,
  String text,
  String channelType,
  String chatId,
);

class MessageQueue {
  final int maxConcurrentGlobal;
  final RunHandler onRun;

  MessageQueue({
    required this.onRun,
    this.maxConcurrentGlobal = 4,
  });

  final Map<String, Queue<QueuedMessage>> _pending = {};
  final Set<String> _activeSessions = {};
  int _globalActiveCount = 0;

  bool isSessionActive(String sessionKey) =>
      _activeSessions.contains(sessionKey);

  int get activeCount => _globalActiveCount;
  int pendingCount(String sessionKey) => _pending[sessionKey]?.length ?? 0;

  Future<void> enqueue(QueuedMessage message) async {
    final key = message.sessionKey;

    if (_activeSessions.contains(key)) {
      // Session is busy -- queue for later (collect mode)
      _pending.putIfAbsent(key, () => Queue());
      _pending[key]!.add(message);
      _log.fine('Queued message for busy session $key '
          '(pending: ${_pending[key]!.length})');
      return;
    }

    if (_globalActiveCount >= maxConcurrentGlobal) {
      _pending.putIfAbsent(key, () => Queue());
      _pending[key]!.add(message);
      _log.fine('Queued message (global cap reached: $_globalActiveCount)');
      return;
    }

    await _execute(message);
  }

  Future<void> _execute(QueuedMessage message) async {
    final key = message.sessionKey;
    _activeSessions.add(key);
    _globalActiveCount++;

    try {
      // Coalesce: if there are pending messages, combine them
      final combined = StringBuffer(message.text);
      final pending = _pending[key];
      if (pending != null && pending.isNotEmpty) {
        while (pending.isNotEmpty) {
          combined.write('\n\n');
          combined.write(pending.removeFirst().text);
        }
      }

      await onRun(
        key,
        combined.toString(),
        message.channelType,
        message.chatId,
      );
    } catch (e) {
      _log.warning('Run failed for session $key: $e');
    } finally {
      _activeSessions.remove(key);
      _globalActiveCount--;

      // Process next queued message for this session
      await _drainNext(key);
    }
  }

  Future<void> _drainNext(String key) async {
    final pending = _pending[key];
    if (pending == null || pending.isEmpty) return;

    final next = pending.removeFirst();
    await _execute(next);
  }
}
