import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutterclaw/channels/channel_interface.dart';
import 'package:flutterclaw/services/pairing_service.dart';
import 'package:logging/logging.dart';

const _apiBase = 'https://api.telegram.org/bot';
const _type = 'telegram';

class TelegramChannelAdapter implements ChannelAdapter {
  TelegramChannelAdapter({
    required this.token,
    this.allowedUserIds = const [],
    this.botUsername,
    this.dmPolicy = 'pairing',
    this.pairingService,
    this.chatCommandHandler,
  }) : _dio = Dio(BaseOptions(
          baseUrl: '$_apiBase$token',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
        ));

  final String token;
  final List<String> allowedUserIds;
  final String? botUsername;
  final String dmPolicy;
  final PairingService? pairingService;
  final Dio _dio;
  final _log = Logger('TelegramChannelAdapter');

  /// Optional: handler for slash commands (returns response text or null to pass through)
  final Future<String?> Function(String sessionKey, String command)?
      chatCommandHandler;

  MessageHandler? _handler;
  bool _running = false;
  int _lastUpdateId = 0;
  int _backoffSeconds = 1;
  final Map<String, Timer> _typingTimers = {};

  static const _maxBackoffSeconds = 300;

  @override
  String get type => _type;

  @override
  bool get isConnected => _running;

  @override
  Future<void> start(MessageHandler handler) async {
    if (_running) {
      _log.warning('Telegram adapter already running');
      return;
    }
    _handler = handler;
    _running = true;
    _backoffSeconds = 1;

    await _registerCommands();
    unawaited(_pollLoop());
  }

  @override
  Future<void> stop() async {
    _running = false;
    _handler = null;
    for (final timer in _typingTimers.values) {
      timer.cancel();
    }
    _typingTimers.clear();
  }

  // -- Typing indicators --

  Future<void> sendTyping(String chatId) async {
    try {
      await _dio.post('/sendChatAction', data: {
        'chat_id': chatId,
        'action': 'typing',
      });
    } catch (_) {}
  }

  void startTyping(String chatId) {
    _typingTimers[chatId]?.cancel();
    sendTyping(chatId);
    _typingTimers[chatId] = Timer.periodic(
      const Duration(seconds: 5),
      (_) => sendTyping(chatId),
    );
  }

  void stopTyping(String chatId) {
    _typingTimers[chatId]?.cancel();
    _typingTimers.remove(chatId);
  }

  // -- Slash command registration --

  Future<void> _registerCommands() async {
    try {
      await _dio.post('/setMyCommands', data: {
        'commands': [
          {'command': 'status', 'description': 'Session status (model, tokens)'},
          {'command': 'new', 'description': 'Start a new session'},
          {'command': 'compact', 'description': 'Compact session context'},
          {'command': 'model', 'description': 'View or switch model'},
          {'command': 'think', 'description': 'Set thinking level'},
          {'command': 'help', 'description': 'Show available commands'},
        ],
      });
      _log.info('Registered Telegram slash commands');
    } catch (e) {
      _log.warning('Failed to register Telegram commands: $e');
    }
  }

  // -- Poll loop --

  Future<void> _pollLoop() async {
    while (_running && _handler != null) {
      try {
        final updates = await _getUpdates();
        _backoffSeconds = 1;

        for (final u in updates) {
          final updateId = u['update_id'] as int;
          if (updateId > _lastUpdateId) _lastUpdateId = updateId;

          final message = u['message'] as Map<String, dynamic>?;
          if (message == null) continue;

          final chat = message['chat'] as Map<String, dynamic>?;
          final from = message['from'] as Map<String, dynamic>?;
          if (chat == null || from == null) continue;

          final chatId = chat['id'];
          if (chatId == null) continue;
          final chatIdStr = chatId.toString();

          final isGroup = (chat['type'] as String?) == 'group' ||
              (chat['type'] as String?) == 'supergroup';
          final senderId = (from['id'] ?? '').toString();
          final senderName = _extractSenderName(from);
          final text = _extractText(message);

          if (text.isEmpty && _extractPhotoUrls(message).isEmpty) continue;

          if (isGroup && botUsername != null) {
            final mention = '@${botUsername!.replaceFirst('@', '')}';
            if (!text.toLowerCase().contains(mention.toLowerCase())) continue;
          }

          // -- DM policy check (non-group only) --
          if (!isGroup) {
            final allowed = await _checkDmPolicy(senderId, senderName, chatIdStr);
            if (!allowed) continue;
          }

          // -- Slash command handling --
          if (text.startsWith('/') && chatCommandHandler != null) {
            final sessionKey = '$_type:$chatIdStr';
            final response = await chatCommandHandler!(sessionKey, text);
            if (response != null) {
              await sendMessage(OutgoingMessage(
                channelType: _type,
                chatId: chatIdStr,
                text: response,
              ));
              continue;
            }
          }

          final replyTo = message['reply_to_message'] != null
              ? (message['reply_to_message'] as Map<String, dynamic>)['message_id'] as int?
              : null;
          final photoUrls = _extractPhotoUrls(message);

          final incoming = IncomingMessage(
            channelType: _type,
            senderId: senderId,
            senderName: senderName,
            chatId: chatIdStr,
            text: text,
            isGroup: isGroup,
            replyToMessageId: replyTo?.toString(),
            timestamp: DateTime.now(),
            photoUrls: photoUrls.isNotEmpty ? photoUrls : null,
          );

          // Start typing indicator
          startTyping(chatIdStr);

          try {
            await _handler!(incoming);
          } catch (e, st) {
            _log.severe('Handler error processing Telegram message', e, st);
          } finally {
            stopTyping(chatIdStr);
          }
        }
      } catch (e, st) {
        _log.warning('Telegram poll error, reconnecting in $_backoffSeconds s', e, st);
        await Future<void>.delayed(Duration(seconds: _backoffSeconds));
        _backoffSeconds = min(_backoffSeconds * 2, _maxBackoffSeconds);
      }
    }
  }

  /// Check DM policy. Returns true if the sender is allowed.
  Future<bool> _checkDmPolicy(
    String senderId,
    String senderName,
    String chatId,
  ) async {
    switch (dmPolicy) {
      case 'open':
        return true;

      case 'disabled':
        return false;

      case 'allowlist':
        if (allowedUserIds.isEmpty) return true;
        return allowedUserIds.contains(senderId);

      case 'pairing':
      default:
        // Static allowlist takes priority
        if (allowedUserIds.isNotEmpty && allowedUserIds.contains(senderId)) {
          return true;
        }

        if (pairingService == null) return true;

        final approved = await pairingService!.isApproved(_type, senderId);
        if (approved) return true;

        // Generate pairing code
        final code = await pairingService!.createRequest(
          _type,
          senderId,
          senderName,
        );

        if (code != null) {
          await sendMessage(OutgoingMessage(
            channelType: _type,
            chatId: chatId,
            text: 'Hi! To use this bot, send this pairing code to the owner:\n\n'
                '$code\n\n'
                'The code expires in 1 hour.',
          ));
        }

        return false;
    }
  }

  // -- Helpers --

  List<String> _extractPhotoUrls(Map<String, dynamic> message) {
    final urls = <String>[];
    final photo = message['photo'] as List<dynamic>?;
    if (photo != null && photo.isNotEmpty) {
      final largest = photo.last as Map<String, dynamic>;
      final fileId = largest['file_id'] as String?;
      if (fileId != null) urls.add('telegram:file:$fileId');
    }
    final doc = message['document'] as Map<String, dynamic>?;
    if (doc != null) {
      final fid = doc['file_id'] as String?;
      if (fid != null) urls.add('telegram:file:$fid');
    }
    return urls;
  }

  String _extractSenderName(Map<String, dynamic> from) {
    final first = from['first_name'] as String? ?? '';
    final last = from['last_name'] as String? ?? '';
    final un = from['username'] as String?;
    if (first.isEmpty && last.isEmpty) return un ?? 'User';
    return '$first $last'.trim();
  }

  String _extractText(Map<String, dynamic> message) {
    final text = message['text'] as String?;
    if (text != null && text.isNotEmpty) return text;
    final caption = message['caption'] as String?;
    if (caption != null && caption.isNotEmpty) return caption;
    return '';
  }

  Future<List<Map<String, dynamic>>> _getUpdates() async {
    final res = await _dio.get<Map<String, dynamic>>(
      '/getUpdates',
      queryParameters: {
        'offset': _lastUpdateId + 1,
        'timeout': 30,
        'allowed_updates': ['message'],
      },
    );
    final data = res.data;
    if (data == null) return [];
    final list = data['result'] as List<dynamic>?;
    return list?.cast<Map<String, dynamic>>() ?? [];
  }

  @override
  Future<void> sendMessage(OutgoingMessage message) async {
    if (message.channelType != _type) return;

    final chunks = _splitMessage(message.text, 4000);
    for (final chunk in chunks) {
      try {
        final params = <String, dynamic>{
          'chat_id': message.chatId,
          'text': chunk,
          'parse_mode': 'Markdown',
        };
        if (message.replyToMessageId != null) {
          params['reply_to_message_id'] =
              int.tryParse(message.replyToMessageId!) ??
                  message.replyToMessageId;
        }
        await _dio.post('/sendMessage', data: params);
      } catch (e, st) {
        _log.severe('Failed to send Telegram message', e, st);
        rethrow;
      }
    }
  }

  List<String> _splitMessage(String text, int maxLen) {
    if (text.length <= maxLen) return [text];
    final chunks = <String>[];
    var remaining = text;
    while (remaining.length > maxLen) {
      var splitAt = remaining.lastIndexOf('\n', maxLen);
      if (splitAt <= 0) splitAt = maxLen;
      chunks.add(remaining.substring(0, splitAt));
      remaining = remaining.substring(splitAt).trimLeft();
    }
    if (remaining.isNotEmpty) chunks.add(remaining);
    return chunks;
  }
}
