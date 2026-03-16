import 'dart:async';

import 'package:flutterclaw/channels/channel_interface.dart';
import 'package:logging/logging.dart';

const _type = 'webchat';

/// In-app WebChat adapter bridging Flutter UI to the agent.
///
/// Uses StreamController for bidirectional communication - no networking.
/// Expose [incomingStream] for the UI to listen to agent replies,
/// and call [sendFromUser] when the user sends a message.
class WebChatChannelAdapter implements ChannelAdapter {
  final _log = Logger('WebChatChannelAdapter');
  final _incomingController = StreamController<IncomingMessage>.broadcast();
  final _outgoingController = StreamController<OutgoingMessage>.broadcast();

  MessageHandler? _handler;
  bool _running = false;

  @override
  String get type => _type;

  @override
  bool get isConnected => _running;

  /// Stream of incoming messages from users (for the agent).
  /// The agent/handler receives via [MessageHandler] - this stream is for
  /// components that need to observe user input.
  Stream<IncomingMessage> get userMessageStream => _incomingController.stream;

  /// Stream of outgoing messages from the agent (for the UI to display).
  Stream<OutgoingMessage> get agentMessageStream => _outgoingController.stream;

  @override
  Future<void> start(MessageHandler handler) async {
    if (_running) {
      _log.warning('WebChat adapter already running');
      return;
    }
    _handler = handler;
    _running = true;
  }

  @override
  Future<void> stop() async {
    _running = false;
    _handler = null;
  }

  /// Call when the adapter is permanently disposed.
  Future<void> dispose() async {
    await stop();
    await _incomingController.close();
    await _outgoingController.close();
  }

  /// Call this when the user sends a message from the UI.
  /// Routes to the agent handler and optionally to [userMessageStream].
  Future<void> sendFromUser({
    required String text,
    String senderId = 'user',
    String senderName = 'User',
    String chatId = 'default',
    bool isGroup = false,
    String? replyToMessageId,
  }) async {
    if (!_running || _handler == null) {
      _log.warning('WebChat adapter not running, dropping user message');
      return;
    }

    final incoming = IncomingMessage(
      channelType: _type,
      senderId: senderId,
      senderName: senderName,
      chatId: chatId,
      text: text,
      isGroup: isGroup,
      replyToMessageId: replyToMessageId,
      timestamp: DateTime.now(),
    );

    _incomingController.add(incoming);

    try {
      await _handler!(incoming);
    } catch (e, st) {
      _log.severe('Handler error processing WebChat message', e, st);
    }
  }

  @override
  Future<void> sendMessage(OutgoingMessage message) async {
    if (message.channelType != _type) return;
    if (!_running) return;
    _outgoingController.add(message);
  }
}
