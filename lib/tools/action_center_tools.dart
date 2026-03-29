/// Action Center tools for FlutterClaw agents.
///
/// action_center_add / action_center_list / action_center_read / action_center_dismiss.
/// Provides a centralized inbox for queuing results, alerts, and tasks
/// for user review.
library;

import 'dart:convert';

import 'package:flutterclaw/services/action_center_service.dart';
import 'package:flutterclaw/tools/registry.dart';

// ---------------------------------------------------------------------------
// action_center_add
// ---------------------------------------------------------------------------

class ActionCenterAddTool extends Tool {
  final ActionCenterService actionCenterService;

  ActionCenterAddTool({required this.actionCenterService});

  @override
  String get name => 'action_center_add';

  @override
  String get description =>
      'Add an item to the action center for user review later.\n\n'
      'Use this to queue results, alerts, or tasks instead of interrupting '
      'the user immediately. Items appear in the action center inbox.\n\n'
      'Types: automationResult, watcherAlert, cronResult, notification, task.\n'
      'Priority: low, normal, high, urgent.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'title': {
            'type': 'string',
            'description': 'Short title for the item',
          },
          'body': {
            'type': 'string',
            'description': 'Detailed content/result/message',
          },
          'type': {
            'type': 'string',
            'enum': [
              'automationResult',
              'watcherAlert',
              'cronResult',
              'notification',
              'task',
            ],
            'description': 'Item type (default: notification)',
            'default': 'notification',
          },
          'priority': {
            'type': 'string',
            'enum': ['low', 'normal', 'high', 'urgent'],
            'description': 'Priority level (default: normal)',
            'default': 'normal',
          },
          'source': {
            'type': 'string',
            'description':
                'Source identifier (e.g. rule ID, watcher ID, cron job ID)',
          },
        },
        'required': ['title', 'body'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final title = (args['title'] as String?)?.trim() ?? '';
    if (title.isEmpty) return ToolResult.error('title is required');

    final body = (args['body'] as String?)?.trim() ?? '';
    if (body.isEmpty) return ToolResult.error('body is required');

    final typeStr = (args['type'] as String?) ?? 'notification';
    final type = ActionItemType.values.firstWhere(
      (t) => t.name == typeStr,
      orElse: () => ActionItemType.notification,
    );

    final priorityStr = (args['priority'] as String?) ?? 'normal';
    final priority = ActionItemPriority.values.firstWhere(
      (p) => p.name == priorityStr,
      orElse: () => ActionItemPriority.normal,
    );

    final source = (args['source'] as String?)?.trim() ?? '';

    final item = ActionItem(
      type: type,
      priority: priority,
      title: title,
      body: body,
      source: source,
    );

    final stored = await actionCenterService.addItem(item);

    return ToolResult.success(jsonEncode({
      'ok': true,
      'id': stored.id,
      'title': stored.title,
      'message': 'Item added to action center.',
    }));
  }
}

// ---------------------------------------------------------------------------
// action_center_list
// ---------------------------------------------------------------------------

class ActionCenterListTool extends Tool {
  final ActionCenterService actionCenterService;

  ActionCenterListTool({required this.actionCenterService});

  @override
  String get name => 'action_center_list';

  @override
  String get description =>
      'List items in the action center inbox. Shows unread items by default.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'status': {
            'type': 'string',
            'enum': ['unread', 'read', 'dismissed', 'all'],
            'description': 'Filter by status. Default: unread.',
            'default': 'unread',
          },
          'limit': {
            'type': 'integer',
            'minimum': 1,
            'maximum': 100,
            'description': 'Max items to return. Default: 50.',
            'default': 50,
          },
        },
        'required': [],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    await actionCenterService.load();

    final statusStr = (args['status'] as String?) ?? 'unread';
    final limit = (args['limit'] as num?)?.toInt() ?? 50;

    ActionItemStatus? status;
    if (statusStr != 'all') {
      status = ActionItemStatus.values.firstWhere(
        (s) => s.name == statusStr,
        orElse: () => ActionItemStatus.unread,
      );
    }

    final items = actionCenterService.getItems(
      status: status,
      limit: limit,
    );

    final list = items.map((i) {
      return {
        'id': i.id,
        'type': i.type.name,
        'priority': i.priority.name,
        'title': i.title,
        'body': i.body.length > 200 ? '${i.body.substring(0, 200)}…' : i.body,
        'status': i.status.name,
        'created_at': i.createdAt.toIso8601String(),
        if (i.source.isNotEmpty) 'source': i.source,
      };
    }).toList();

    return ToolResult.success(jsonEncode({
      'ok': true,
      'unread_total': actionCenterService.unreadCount,
      'returned': list.length,
      'items': list,
    }));
  }
}

// ---------------------------------------------------------------------------
// action_center_read
// ---------------------------------------------------------------------------

class ActionCenterReadTool extends Tool {
  final ActionCenterService actionCenterService;

  ActionCenterReadTool({required this.actionCenterService});

  @override
  String get name => 'action_center_read';

  @override
  String get description =>
      'Mark action center items as read. Pass an item id, or "all" to mark all as read.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'id': {
            'type': 'string',
            'description': 'Item id to mark as read, or "all" for all items',
          },
        },
        'required': ['id'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final id = (args['id'] as String?)?.trim() ?? '';
    if (id.isEmpty) return ToolResult.error('id is required');

    if (id == 'all') {
      await actionCenterService.markAllRead();
      return ToolResult.success(jsonEncode({
        'ok': true,
        'message': 'All items marked as read.',
      }));
    }

    final existing =
        actionCenterService.items.where((i) => i.id == id).firstOrNull;
    if (existing == null) {
      return ToolResult.error('No item found with id "$id"');
    }

    await actionCenterService.markRead(id);

    return ToolResult.success(jsonEncode({
      'ok': true,
      'id': id,
      'title': existing.title,
      'message': 'Item marked as read.',
    }));
  }
}

// ---------------------------------------------------------------------------
// action_center_dismiss
// ---------------------------------------------------------------------------

class ActionCenterDismissTool extends Tool {
  final ActionCenterService actionCenterService;

  ActionCenterDismissTool({required this.actionCenterService});

  @override
  String get name => 'action_center_dismiss';

  @override
  String get description =>
      'Dismiss action center items. Pass an item id, or "all" to dismiss all.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'id': {
            'type': 'string',
            'description': 'Item id to dismiss, or "all" for all items',
          },
        },
        'required': ['id'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final id = (args['id'] as String?)?.trim() ?? '';
    if (id.isEmpty) return ToolResult.error('id is required');

    if (id == 'all') {
      await actionCenterService.dismissAll();
      return ToolResult.success(jsonEncode({
        'ok': true,
        'message': 'All items dismissed.',
      }));
    }

    final existing =
        actionCenterService.items.where((i) => i.id == id).firstOrNull;
    if (existing == null) {
      return ToolResult.error('No item found with id "$id"');
    }

    await actionCenterService.dismiss(id);

    return ToolResult.success(jsonEncode({
      'ok': true,
      'id': id,
      'title': existing.title,
      'message': 'Item dismissed.',
    }));
  }
}
