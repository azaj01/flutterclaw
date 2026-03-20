/// Base types for the channel adapter system.
///
/// All channel adapters (Telegram, Discord, WebChat) implement [ChannelAdapter]
/// and exchange [IncomingMessage] / [OutgoingMessage] through a [MessageHandler].
library;

import 'dart:typed_data';

typedef MessageHandler = Future<void> Function(IncomingMessage message);

/// Represents a message received from any channel.
class IncomingMessage {
  final String channelType; // 'telegram', 'discord', 'webchat', 'whatsapp'
  final String senderId;
  final String senderName;
  final String chatId;
  final String text;
  final bool isGroup;
  final String? messageId;
  final String? participantId;
  final String? replyToMessageId;
  final DateTime timestamp;
  final List<String>? photoUrls;
  final String? action;
  final String? emoji;
  final String? targetMessageId;
  final bool? fromMe;
  final Map<String, dynamic>? channelContext;
  final List<Map<String, dynamic>>? contentBlocks;

  /// Raw audio bytes for voice messages (e.g. OGG/Opus from Telegram/WhatsApp).
  /// Null for text/image messages. The router transcribes this before forwarding.
  final Uint8List? audioBytes;

  /// File format hint for [audioBytes] ('ogg', 'm4a', 'wav', 'mp3').
  final String? audioFormat;

  /// Duration of the voice message in seconds (for display/logging).
  final int? audioDuration;

  const IncomingMessage({
    required this.channelType,
    required this.senderId,
    required this.senderName,
    required this.chatId,
    required this.text,
    this.isGroup = false,
    this.messageId,
    this.participantId,
    this.replyToMessageId,
    required this.timestamp,
    this.photoUrls,
    this.action,
    this.emoji,
    this.targetMessageId,
    this.fromMe,
    this.channelContext,
    this.contentBlocks,
    this.audioBytes,
    this.audioFormat,
    this.audioDuration,
  });

  /// Session key for per-channel isolation (channel + chatId).
  String get sessionKey => '$channelType:$chatId';

  IncomingMessage copyWith({
    String? channelType,
    String? senderId,
    String? senderName,
    String? chatId,
    String? text,
    bool? isGroup,
    String? messageId,
    String? participantId,
    String? replyToMessageId,
    DateTime? timestamp,
    List<String>? photoUrls,
    String? action,
    String? emoji,
    String? targetMessageId,
    bool? fromMe,
    Map<String, dynamic>? channelContext,
    List<Map<String, dynamic>>? contentBlocks,
    Uint8List? audioBytes,
    String? audioFormat,
    int? audioDuration,
    bool clearAudio = false,
  }) {
    return IncomingMessage(
      channelType: channelType ?? this.channelType,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      chatId: chatId ?? this.chatId,
      text: text ?? this.text,
      isGroup: isGroup ?? this.isGroup,
      messageId: messageId ?? this.messageId,
      participantId: participantId ?? this.participantId,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      timestamp: timestamp ?? this.timestamp,
      photoUrls: photoUrls ?? this.photoUrls,
      action: action ?? this.action,
      emoji: emoji ?? this.emoji,
      targetMessageId: targetMessageId ?? this.targetMessageId,
      fromMe: fromMe ?? this.fromMe,
      channelContext: channelContext ?? this.channelContext,
      contentBlocks: contentBlocks ?? this.contentBlocks,
      audioBytes: clearAudio ? null : (audioBytes ?? this.audioBytes),
      audioFormat: clearAudio ? null : (audioFormat ?? this.audioFormat),
      audioDuration: clearAudio ? null : (audioDuration ?? this.audioDuration),
    );
  }
}

/// Represents a message to be sent to any channel.
class OutgoingMessage {
  final String channelType;
  final String chatId;
  final String text;
  final String? replyToMessageId;
  final List<String>? photoUrls;
  final String? action;
  final String? targetMessageId;
  final String? emoji;
  final String? participantId;
  final bool? fromMe;

  /// Audio bytes to send as a voice note or audio file.
  /// When non-null, the adapter sends this audio in addition to [text].
  final Uint8List? audioBytes;

  /// MIME type for [audioBytes] (e.g. 'audio/ogg; codecs=opus', 'audio/wav').
  final String? audioMimeType;

  /// If true, send audio as a push-to-talk voice note (PTT).
  /// If false, send as an audio file attachment.
  final bool isVoiceNote;

  const OutgoingMessage({
    required this.channelType,
    required this.chatId,
    required this.text,
    this.replyToMessageId,
    this.photoUrls,
    this.action,
    this.targetMessageId,
    this.emoji,
    this.participantId,
    this.fromMe,
    this.audioBytes,
    this.audioMimeType,
    this.isVoiceNote = true,
  });
}

/// Abstract base for channel adapters.
abstract class ChannelAdapter {
  String get type;
  bool get isConnected;

  Future<void> start(MessageHandler handler);
  Future<void> stop();
  Future<void> sendMessage(OutgoingMessage message);
}
