/// Per-session message queue matching OpenClaw's lane-based serialization.
///
/// Ensures only one agent run executes per session at a time.
/// Queued text messages are coalesced into the next turn (collect mode).
library;

import 'dart:async';
import 'dart:collection';

import 'package:flutterclaw/core/agent/agent_loop.dart';
import 'package:logging/logging.dart';

final _log = Logger('flutterclaw.message_queue');

class QueuedMessage {
  final String sessionKey;
  final String text;
  final String channelType;
  final String chatId;
  final List<Map<String, dynamic>>? contentBlocks;
  final Map<String, dynamic>? channelContext;
  final Future<void> Function(String text)? onIntermediateMessage;
  final DateTime queuedAt;

  QueuedMessage({
    required this.sessionKey,
    required this.text,
    required this.channelType,
    required this.chatId,
    this.contentBlocks,
    this.channelContext,
    this.onIntermediateMessage,
  }) : queuedAt = DateTime.now();

  /// Rich messages (images, audio metadata) must not be coalesced with others.
  bool get isRich =>
      contentBlocks != null && contentBlocks!.isNotEmpty;
}

typedef RunHandler = Future<AgentResponse> Function(QueuedMessage message);

class _QueueItem {
  _QueueItem(this.message, this.completer);
  final QueuedMessage message;
  final Completer<AgentResponse> completer;
}

class MessageQueue {
  final int maxConcurrentGlobal;
  final RunHandler onRun;

  MessageQueue({
    required this.onRun,
    this.maxConcurrentGlobal = 4,
  });

  final Map<String, Queue<_QueueItem>> _pending = {};
  final Set<String> _activeSessions = {};
  int _globalActiveCount = 0;

  bool isSessionActive(String sessionKey) =>
      _activeSessions.contains(sessionKey);

  int get activeCount => _globalActiveCount;
  int pendingCount(String sessionKey) => _pending[sessionKey]?.length ?? 0;

  /// Enqueue a run. Returns the [AgentResponse] when this message's turn completes.
  Future<AgentResponse> enqueue(QueuedMessage message) {
    final completer = Completer<AgentResponse>();
    final item = _QueueItem(message, completer);
    final key = message.sessionKey;

    if (_activeSessions.contains(key)) {
      _pending.putIfAbsent(key, () => Queue());
      _pending[key]!.add(item);
      _log.fine('Queued message for busy session $key '
          '(pending: ${_pending[key]!.length})');
      return completer.future;
    }

    if (_globalActiveCount >= maxConcurrentGlobal) {
      _pending.putIfAbsent(key, () => Queue());
      _pending[key]!.add(item);
      _log.fine('Queued message (global cap reached: $_globalActiveCount)');
      return completer.future;
    }

    unawaited(_execute(item));
    return completer.future;
  }

  /// Convenience for text-only ingress (webhook, heartbeat, subagents).
  Future<AgentResponse> enqueueText({
    required String sessionKey,
    required String text,
    String channelType = 'system',
    String chatId = 'default',
  }) {
    return enqueue(QueuedMessage(
      sessionKey: sessionKey,
      text: text,
      channelType: channelType,
      chatId: chatId,
    ));
  }

  Future<void> _execute(_QueueItem item) async {
    final key = item.message.sessionKey;
    _activeSessions.add(key);
    _globalActiveCount++;

    final (combined, waiters) = _coalescePending(item);

    try {
      final response = await onRun(combined);
      for (final waiter in waiters) {
        if (!waiter.completer.isCompleted) {
          waiter.completer.complete(response);
        }
      }
    } catch (e, st) {
      _log.warning('Run failed for session $key: $e', e, st);
      for (final waiter in waiters) {
        if (!waiter.completer.isCompleted) {
          waiter.completer.completeError(e, st);
        }
      }
    } finally {
      _activeSessions.remove(key);
      _globalActiveCount--;
      await _drainNext(key);
    }
  }

  /// Returns combined message and all waiters that share this run's response.
  (QueuedMessage, List<_QueueItem>) _coalescePending(_QueueItem item) {
    final waiters = <_QueueItem>[item];
    if (item.message.isRich) return (item.message, waiters);

    final pending = _pending[item.message.sessionKey];
    if (pending == null || pending.isEmpty) return (item.message, waiters);

    final combinedText = StringBuffer(item.message.text);
    while (pending.isNotEmpty && !pending.first.message.isRich) {
      final next = pending.removeFirst();
      waiters.add(next);
      combinedText.write('\n\n');
      combinedText.write(next.message.text);
    }

    final combined = QueuedMessage(
      sessionKey: item.message.sessionKey,
      text: combinedText.toString(),
      channelType: item.message.channelType,
      chatId: item.message.chatId,
      contentBlocks: item.message.contentBlocks,
      channelContext: item.message.channelContext,
      onIntermediateMessage: item.message.onIntermediateMessage,
    );
    return (combined, waiters);
  }

  Future<void> _drainNext(String key) async {
    final pending = _pending[key];
    if (pending == null || pending.isEmpty) return;

    final next = pending.removeFirst();
    await _execute(next);
  }
}
