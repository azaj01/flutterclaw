/// Cross-channel message routing tools for FlutterClaw.
///
/// Provides a convenience tool to create cross-channel forwarding rules.
/// Under the hood, this creates automation rules that forward messages
/// from one channel to another using the existing message tool.
library;

import 'dart:convert';

import 'package:flutterclaw/services/automation_service.dart';
import 'package:flutterclaw/tools/registry.dart';

// ---------------------------------------------------------------------------
// route_create
// ---------------------------------------------------------------------------

class RouteCreateTool extends Tool {
  final AutomationService automationService;

  RouteCreateTool({required this.automationService});

  @override
  String get name => 'route_create';

  @override
  String get description =>
      'Create a cross-channel message forwarding rule.\n\n'
      'Forwards messages arriving on one channel to another. This creates an '
      'automation rule under the hood.\n\n'
      'Examples:\n'
      '  • Forward all Telegram messages to Discord\n'
      '  • Forward WhatsApp messages containing "urgent" to Telegram\n'
      '  • Forward webhook events to Slack\n\n'
      'The source is a channel type or event source pattern. The destination '
      'is a channel:chat_id pair (use channel_sessions to find active sessions).';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'name': {
            'type': 'string',
            'description': 'Name for the routing rule (e.g. "Telegram → Discord")',
          },
          'from_channel': {
            'type': 'string',
            'description':
                'Source channel type to listen on (e.g. "telegram", "whatsapp", '
                    '"discord", "slack", "webhook"). Use "*" for all channels.',
          },
          'to_channel': {
            'type': 'string',
            'description':
                'Destination channel type (e.g. "telegram", "discord")',
          },
          'to_chat_id': {
            'type': 'string',
            'description':
                'Chat ID on the destination channel. Use channel_sessions '
                    'to find active chat IDs.',
          },
          'filter_text': {
            'type': 'string',
            'description':
                'Optional: only forward messages containing this text '
                    '(case-insensitive). Leave empty to forward all.',
          },
        },
        'required': ['name', 'from_channel', 'to_channel', 'to_chat_id'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final routeName = (args['name'] as String?)?.trim() ?? '';
    if (routeName.isEmpty) return ToolResult.error('name is required');

    final fromChannel = (args['from_channel'] as String?)?.trim() ?? '';
    if (fromChannel.isEmpty) return ToolResult.error('from_channel is required');

    final toChannel = (args['to_channel'] as String?)?.trim() ?? '';
    if (toChannel.isEmpty) return ToolResult.error('to_channel is required');

    final toChatId = (args['to_chat_id'] as String?)?.trim() ?? '';
    if (toChatId.isEmpty) return ToolResult.error('to_chat_id is required');

    final filterText = (args['filter_text'] as String?)?.trim() ?? '';

    // Build the automation rule condition
    final eventType = fromChannel == '*' ? '*' : 'channelMessage';
    final sourcePattern = fromChannel == '*' ? '' : fromChannel;

    final condition = RuleCondition(
      eventType: eventType,
      sourcePattern: sourcePattern,
      payloadField: filterText.isNotEmpty ? 'text' : '',
      operator: 'contains',
      value: filterText,
    );

    // Build the task that forwards the message
    final task =
        'A message was received that needs to be forwarded to $toChannel (chat_id: $toChatId). '
        'Read the trigger event details to get the original message text and sender. '
        'Then use the "message" tool with chat_id "$toChannel:$toChatId" to forward it. '
        'Format: "[Forwarded from {source}] {sender}: {message text}". '
        'Then call send_notification with a brief summary.';

    final rule = AutomationRule(
      name: routeName,
      description: 'Cross-channel route: $fromChannel → $toChannel:$toChatId'
          '${filterText.isNotEmpty ? ' (filter: "$filterText")' : ''}',
      condition: condition,
      task: task,
    );

    final stored = await automationService.addRule(rule);

    return ToolResult.success(jsonEncode({
      'ok': true,
      'rule_id': stored.id,
      'name': stored.name,
      'from': fromChannel,
      'to': '$toChannel:$toChatId',
      if (filterText.isNotEmpty) 'filter': filterText,
      'message':
          'Route "${stored.name}" created: $fromChannel → $toChannel:$toChatId. '
              'Messages will be forwarded automatically when they arrive.',
    }));
  }
}

// ---------------------------------------------------------------------------
// route_list
// ---------------------------------------------------------------------------

class RouteListTool extends Tool {
  final AutomationService automationService;

  RouteListTool({required this.automationService});

  @override
  String get name => 'route_list';

  @override
  String get description =>
      'List all cross-channel routing rules. '
      'These are automation rules with "Cross-channel route" descriptions.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {},
        'required': [],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final routes = automationService.rules
        .where((r) => r.description.startsWith('Cross-channel route:'))
        .toList();

    final list = routes.map((r) {
      return {
        'rule_id': r.id,
        'name': r.name,
        'description': r.description,
        'enabled': r.enabled,
        'fire_count': r.fireCount,
        'last_fired': r.lastFiredAt?.toIso8601String(),
      };
    }).toList();

    return ToolResult.success(jsonEncode({
      'ok': true,
      'count': list.length,
      'routes': list,
      'tip': 'Use automation_delete with the rule_id to remove a route, '
          'or automation_update to enable/disable it.',
    }));
  }
}
