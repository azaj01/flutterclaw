/// Message tool for FlutterClaw.
///
/// Sends messages to channels (Telegram, Discord, etc.) and discovers
/// active channel sessions / paired devices.
library;

import 'dart:convert';

import 'package:flutterclaw/core/agent/session_manager.dart';
import 'package:flutterclaw/services/pairing_service.dart';
import 'registry.dart';

/// Callback invoked when a message send is requested.
typedef MessageSendCallback = Future<void> Function({
  required String channel,
  required String target,
  required String text,
  String? action,
});

/// Sends a message to a channel (Telegram, Discord, etc.).
///
/// Use `channel_sessions` first to discover the target chat_id if you don't
/// already know it.
class MessageTool extends Tool {
  final MessageSendCallback onSend;

  MessageTool(this.onSend);

  @override
  String get name => 'message';

  @override
  String get description =>
      'Send a message to a channel (telegram, discord, webchat).\n\n'
      'If you don\'t know the target chat_id, call channel_sessions first to '
      'discover active sessions and paired devices, then use the chat_id from '
      'the results.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'channel': {
            'type': 'string',
            'description': 'Channel type: "telegram", "discord", or "webchat".',
          },
          'target': {
            'type': 'string',
            'description':
                'Target chat_id for the channel. Use channel_sessions to find it.',
          },
          'text': {
            'type': 'string',
            'description': 'Message text to send.',
          },
        },
        'required': ['channel', 'target', 'text'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final channel = args['channel'] as String?;
    final target = args['target'] as String?;
    final text = args['text'] as String?;

    if (channel == null || channel.isEmpty) {
      return ToolResult.error('channel is required');
    }
    if (target == null || target.isEmpty) {
      return ToolResult.error('target is required');
    }
    if (text == null || text.isEmpty) {
      return ToolResult.error('text is required');
    }

    try {
      await onSend(
        channel: channel,
        target: target,
        text: text,
      );
      return ToolResult.success('Message sent to $channel:$target');
    } catch (e) {
      return ToolResult.error('Message send failed: $e');
    }
  }
}

// ---------------------------------------------------------------------------
// channel_sessions — discover active channel sessions and paired devices
// ---------------------------------------------------------------------------

/// Lists active channel sessions and paired devices so the agent can find
/// the right chat_id for sending messages.
class ChannelSessionsTool extends Tool {
  final SessionManager sessionManager;
  final PairingService pairingService;

  ChannelSessionsTool({
    required this.sessionManager,
    required this.pairingService,
  });

  @override
  String get name => 'channel_sessions';

  @override
  String get description =>
      'List active channel sessions and paired devices. '
      'Use this to find the chat_id needed by the "message" tool.\n\n'
      'Returns sessions grouped by channel (telegram, discord, webchat) with '
      'chat_id, last activity, and paired device names.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'channel': {
            'type': 'string',
            'description':
                'Optional: filter by channel type (telegram, discord, webchat). '
                'Omit to list all channels.',
          },
        },
        'required': [],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final filterChannel = (args['channel'] as String?)?.trim().toLowerCase();

    // Gather active sessions grouped by channel type
    final sessions = sessionManager.listActiveSessions();
    final channelSessions = <String, List<Map<String, dynamic>>>{};

    for (final s in sessions) {
      if (filterChannel != null && s.channelType != filterChannel) continue;
      // Skip internal sessions (cron, subagent, heartbeat)
      if (s.channelType == 'cron' ||
          s.key.startsWith('cron:') ||
          s.key.startsWith('subagent:') ||
          s.key.startsWith('heartbeat:')) {
        continue;
      }

      channelSessions.putIfAbsent(s.channelType, () => []).add({
        'session_key': s.key,
        'chat_id': s.chatId,
        'last_activity': s.lastActivity.toIso8601String(),
        'message_count': s.messageCount,
      });
    }

    // Gather paired devices per channel
    final pairedDevices = <String, List<Map<String, String>>>{};
    for (final channel in ['telegram', 'discord']) {
      if (filterChannel != null && channel != filterChannel) continue;
      final approved = await pairingService.getApproved(channel);
      if (approved.isNotEmpty) {
        pairedDevices[channel] = approved.entries
            .map((e) => {'id': e.key, 'name': e.value})
            .toList();
      }
    }

    return ToolResult.success(jsonEncode({
      'ok': true,
      'sessions': channelSessions,
      'paired_devices': pairedDevices,
    }));
  }
}
