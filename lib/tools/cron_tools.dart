/// Cron job management tools.
///
/// Ports OpenClaw's cron_create / cron_list / cron_delete / cron_update tools.
library;

import 'dart:convert';

import 'package:flutterclaw/services/cron_service.dart';
import 'package:flutterclaw/services/notification_service.dart';
import 'package:flutterclaw/tools/registry.dart';

// ---------------------------------------------------------------------------
// cron_create
// ---------------------------------------------------------------------------

class CronCreateTool extends Tool {
  final CronService cronService;
  final NotificationService notificationService;

  CronCreateTool({
    required this.cronService,
    required this.notificationService,
  });

  @override
  String get name => 'cron_create';

  @override
  String get description =>
      'Schedule a task to run at a specific time or on a recurring schedule.\n\n'
      'Schedule options (exactly one required):\n'
      '  • cron_expression — 5-field cron syntax "min hour day month weekday"\n'
      '      "*/5 * * * *"   every 5 minutes\n'
      '      "0 9 * * *"     daily at 9 AM\n'
      '      "0 9 * * 1"     every Monday at 9 AM\n'
      '  • interval_minutes — repeat every N minutes (e.g. 60 = hourly)\n'
      '  • run_at — ISO8601 datetime to run exactly once (e.g. "2025-06-01T09:00:00")\n\n'
      'Use repeat: false with interval_minutes to run once in N minutes then auto-delete.\n\n'
      'The task string is the instruction the agent will execute when the job fires. '
      'Always end the task with "then call send_notification with the result" so the '
      'user gets notified.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'name': {
            'type': 'string',
            'description': 'Short human-readable name (e.g. "Morning brief")',
          },
          'task': {
            'type': 'string',
            'description':
                'Instructions the agent executes when the job fires. '
                'Include all context needed and end with "then call send_notification with the result".',
          },
          'cron_expression': {
            'type': 'string',
            'description':
                '5-field cron expression for recurring time-based schedules. '
                'Mutually exclusive with interval_minutes and run_at.',
          },
          'interval_minutes': {
            'type': 'integer',
            'minimum': 1,
            'description':
                'Run every N minutes. Combine with repeat: false to run once in N minutes. '
                'Mutually exclusive with cron_expression and run_at.',
          },
          'run_at': {
            'type': 'string',
            'description':
                'ISO8601 datetime to run exactly once (implies repeat: false). '
                'Example: "2025-06-01T09:30:00". '
                'Mutually exclusive with cron_expression and interval_minutes.',
          },
          'repeat': {
            'type': 'boolean',
            'description':
                'Whether the job repeats after running (default true). '
                'Set to false to run once then auto-delete. '
                'Ignored when using run_at (always one-shot).',
            'default': true,
          },
        },
        'required': ['name', 'task'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final name = (args['name'] as String?)?.trim() ?? '';
    final task = (args['task'] as String?)?.trim() ?? '';

    if (name.isEmpty) return ToolResult.error('name is required');
    if (task.isEmpty) return ToolResult.error('task is required');

    final cronExpr = args['cron_expression'] as String?;
    final intervalMinutes = args['interval_minutes'];
    final runAtStr = args['run_at'] as String?;
    final repeatRaw = args['repeat'];
    bool repeat = repeatRaw is bool ? repeatRaw : true;

    // Validate: exactly one schedule option
    final scheduleCount = [
      cronExpr != null,
      intervalMinutes != null,
      runAtStr != null,
    ].where((x) => x).length;

    if (scheduleCount == 0) {
      return ToolResult.error(
          'Provide exactly one of: cron_expression, interval_minutes, or run_at');
    }
    if (scheduleCount > 1) {
      return ToolResult.error(
          'Provide only one of: cron_expression, interval_minutes, or run_at');
    }

    Duration? interval;
    String? validatedExpr;
    DateTime? runAt;

    if (intervalMinutes != null) {
      final mins = intervalMinutes is num ? intervalMinutes.toInt() : 0;
      if (mins < 1) return ToolResult.error('interval_minutes must be >= 1');
      interval = Duration(minutes: mins);
    }

    if (cronExpr != null) {
      final err = CronService.validateCronExpression(cronExpr);
      if (err != null) return ToolResult.error('Invalid cron_expression: $err');
      validatedExpr = cronExpr.trim();
    }

    if (runAtStr != null) {
      try {
        runAt = DateTime.parse(runAtStr);
        if (runAt.isBefore(DateTime.now())) {
          return ToolResult.error(
              'run_at "$runAtStr" is in the past. Provide a future datetime.');
        }
      } catch (_) {
        return ToolResult.error(
            'Invalid run_at "$runAtStr". Use ISO8601 format e.g. "2025-06-01T09:30:00"');
      }
      repeat = false; // run_at is always one-shot
    }

    final job = CronJob(
      name: name,
      task: task,
      cronExpression: validatedExpr,
      interval: interval,
      repeat: repeat,
      nextRunAt: runAt, // explicit for run_at; null otherwise (computed in addJob)
    );

    // Cron jobs almost always need push notifications — request permissions now
    // so the user isn't prompted mid-execution when it's too late.
    await notificationService.initialize();

    final stored = await cronService.addJob(job);

    return ToolResult.success(jsonEncode({
      'ok': true,
      'id': stored.id,
      'name': stored.name,
      'schedule': stored.scheduleDisplay,
      'repeat': stored.repeat,
      'next_run': stored.nextRunAt?.toIso8601String(),
      'message': stored.repeat
          ? 'Job "${stored.name}" scheduled. Next run: ${stored.nextRunAt?.toLocal().toString().substring(0, 16)}.'
          : 'Job "${stored.name}" scheduled once at ${stored.nextRunAt?.toLocal().toString().substring(0, 16)}. Will auto-delete after running.',
    }));
  }
}

// ---------------------------------------------------------------------------
// cron_list
// ---------------------------------------------------------------------------

class CronListTool extends Tool {
  final CronService cronService;

  CronListTool({required this.cronService});

  @override
  String get name => 'cron_list';

  @override
  String get description =>
      'List all scheduled cron jobs with their status, schedule, run history, '
      'and any errors from the last execution.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {},
        'required': [],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final jobs = cronService.jobs;

    final list = jobs.map((j) {
      return {
        'id': j.id,
        'name': j.name,
        'task': j.task.length > 120 ? '${j.task.substring(0, 120)}…' : j.task,
        'schedule': j.scheduleDisplay,
        'repeat': j.repeat,
        'enabled': j.enabled,
        'status': j.lastStatus.name,
        'run_count': j.runCount,
        'last_run': j.lastRunAt?.toIso8601String(),
        'next_run': j.nextRunAt?.toIso8601String(),
        if (j.lastError != null) 'last_error': j.lastError,
      };
    }).toList();

    return ToolResult.success(jsonEncode({
      'ok': true,
      'count': list.length,
      'jobs': list,
    }));
  }
}

// ---------------------------------------------------------------------------
// cron_delete
// ---------------------------------------------------------------------------

class CronDeleteTool extends Tool {
  final CronService cronService;

  CronDeleteTool({required this.cronService});

  @override
  String get name => 'cron_delete';

  @override
  String get description =>
      'Delete a cron job by id. Use cron_list to find the id first.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'id': {
            'type': 'string',
            'description': 'The id of the cron job to delete',
          },
        },
        'required': ['id'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final id = (args['id'] as String?)?.trim() ?? '';
    if (id.isEmpty) return ToolResult.error('id is required');

    final existing =
        cronService.jobs.where((j) => j.id == id).firstOrNull;
    if (existing == null) {
      return ToolResult.error('No cron job found with id "$id"');
    }

    await cronService.removeJob(id);

    return ToolResult.success(jsonEncode({
      'ok': true,
      'deleted_id': id,
      'deleted_name': existing.name,
      'message': 'Cron job "${existing.name}" deleted.',
    }));
  }
}

// ---------------------------------------------------------------------------
// cron_update
// ---------------------------------------------------------------------------

class CronUpdateTool extends Tool {
  final CronService cronService;

  CronUpdateTool({required this.cronService});

  @override
  String get name => 'cron_update';

  @override
  String get description =>
      'Pause, resume, or update the task of an existing cron job. '
      'Use cron_list to find the id first.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'id': {
            'type': 'string',
            'description': 'The id of the cron job to update',
          },
          'enabled': {
            'type': 'boolean',
            'description': 'true to resume, false to pause',
          },
          'task': {
            'type': 'string',
            'description': 'New task instructions to replace the existing ones',
          },
        },
        'required': ['id'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final id = (args['id'] as String?)?.trim() ?? '';
    if (id.isEmpty) return ToolResult.error('id is required');

    final existing =
        cronService.jobs.where((j) => j.id == id).firstOrNull;
    if (existing == null) {
      return ToolResult.error('No cron job found with id "$id"');
    }

    final enabled = args['enabled'] as bool?;
    final task = (args['task'] as String?)?.trim();

    if (enabled == null && (task == null || task.isEmpty)) {
      return ToolResult.error('Provide at least one of: enabled, task');
    }

    await cronService.updateJob(id, enabled: enabled, task: task);

    return ToolResult.success(jsonEncode({
      'ok': true,
      'id': id,
      'name': existing.name,
      'enabled': enabled ?? existing.enabled,
      'task_updated': task != null,
      'message': 'Cron job "${existing.name}" updated.',
    }));
  }
}
