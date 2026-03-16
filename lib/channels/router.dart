import 'dart:async';
import 'dart:collection';

import 'package:flutterclaw/channels/channel_interface.dart';
import 'package:logging/logging.dart';

/// Routes messages between channel adapters and the agent.
///
/// - Forwards incoming messages to the agent
/// - Sends outgoing messages to the correct channel adapter
/// - Provides per-channel session isolation via session keys
/// - Buffers outgoing messages when a channel is offline
class ChannelRouter {
  ChannelRouter({
    this.agentHandler,
    this.maxQueueSize = 100,
  });

  final _log = Logger('ChannelRouter');
  final Map<String, ChannelAdapter> _adapters = {};
  final Map<String, Queue<OutgoingMessage>> _pendingQueues = {};
  final int maxQueueSize;

  /// Called for each incoming message. Set this to your agent's handler.
  MessageHandler? agentHandler;

  bool _running = false;

  bool get isRunning => _running;

  /// All registered adapters (for status display).
  List<ChannelAdapter> get adapters => _adapters.values.toList();

  /// Register a channel adapter.
  void registerAdapter(ChannelAdapter adapter) {
    if (_adapters.containsKey(adapter.type)) {
      _log.warning('Replacing existing adapter for type ${adapter.type}');
    }
    _adapters[adapter.type] = adapter;
  }

  /// Unregister a channel adapter by type.
  void unregisterAdapter(String type) {
    _adapters.remove(type);
    _pendingQueues.remove(type);
  }

  /// Get session key for isolation (channel + chatId).
  String sessionKey(IncomingMessage msg) => msg.sessionKey;

  /// Start all registered adapters.
  Future<void> start() async {
    if (_running) {
      _log.warning('Router already running');
      return;
    }
    _running = true;
    for (final adapter in _adapters.values) {
      try {
        await adapter.start(_handleIncoming);
        _log.info('Started channel ${adapter.type}');
      } catch (e, st) {
        _log.severe('Failed to start channel ${adapter.type}', e, st);
      }
    }
  }

  /// Stop all adapters and flush pending queues.
  Future<void> stop() async {
    _running = false;
    for (final adapter in _adapters.values) {
      try {
        await adapter.stop();
        _log.info('Stopped channel ${adapter.type}');
      } catch (e, st) {
        _log.warning('Error stopping channel ${adapter.type}', e, st);
      }
    }
    _pendingQueues.clear();
  }

  /// Send a message to the appropriate channel. Queues if channel is offline.
  Future<void> sendMessage(OutgoingMessage message) async {
    final adapter = _adapters[message.channelType];
    if (adapter == null) {
      _log.warning('No adapter for channel ${message.channelType}, dropping message');
      return;
    }

    if (!adapter.isConnected) {
      _enqueue(message);
      return;
    }

    try {
      await adapter.sendMessage(message);
      await _flushPending(message.channelType);
    } catch (e, st) {
      _log.warning('Send failed for ${message.channelType}, queuing', e, st);
      _enqueue(message);
    }
  }

  void _enqueue(OutgoingMessage message) {
    final queue = _pendingQueues.putIfAbsent(
      message.channelType,
      () => Queue<OutgoingMessage>(),
    );
    if (queue.length >= maxQueueSize) {
      queue.removeFirst();
      _log.warning('Pending queue full for ${message.channelType}, dropped oldest');
    }
    queue.add(message);
  }

  Future<void> _flushPending(String channelType) async {
    final queue = _pendingQueues[channelType];
    if (queue == null || queue.isEmpty) return;

    final adapter = _adapters[channelType];
    if (adapter == null || !adapter.isConnected) return;

    while (queue.isNotEmpty) {
      final msg = queue.removeFirst();
      try {
        await adapter.sendMessage(msg);
      } catch (e, st) {
        _log.warning('Failed to flush pending message', e, st);
        queue.addFirst(msg);
        break;
      }
    }
  }

  Future<void> _handleIncoming(IncomingMessage message) async {
    final handler = agentHandler;
    if (handler == null) {
      _log.fine('No agent handler set, dropping incoming message');
      return;
    }
    try {
      await handler(message);
    } catch (e, st) {
      _log.severe('Agent handler error', e, st);
    }
  }
}
