/// Calendar tools for FlutterClaw agents.
///
/// Read and create calendar events via device_calendar.
library;

import 'dart:convert';

import 'package:device_calendar/device_calendar.dart';
import 'package:timezone/timezone.dart' as tz;
import 'registry.dart';

final _calPlugin = DeviceCalendarPlugin();

/// List calendar events within a date range.
class CalendarListEventsTool extends Tool {
  @override
  String get name => 'calendar_list_events';

  @override
  String get description =>
      'List calendar events between two dates. '
      'If no calendar_id is given, events from all calendars are returned. '
      'Requires calendar permission (will prompt the user if needed).';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'start_date': {
            'type': 'string',
            'description': 'Start of the date range (ISO 8601), e.g. "2025-03-14".',
          },
          'end_date': {
            'type': 'string',
            'description': 'End of the date range (ISO 8601), e.g. "2025-03-21".',
          },
          'calendar_id': {
            'type': 'string',
            'description': 'Optional calendar ID to filter. Omit to query all calendars.',
          },
        },
        'required': ['start_date', 'end_date'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final startStr = (args['start_date'] as String?)?.trim() ?? '';
    final endStr = (args['end_date'] as String?)?.trim() ?? '';
    final calendarId = (args['calendar_id'] as String?)?.trim();

    if (startStr.isEmpty) return ToolResult.error('start_date is required');
    if (endStr.isEmpty) return ToolResult.error('end_date is required');

    final startDate = DateTime.tryParse(startStr);
    final endDate = DateTime.tryParse(endStr);
    if (startDate == null) return ToolResult.error('Invalid start_date format');
    if (endDate == null) return ToolResult.error('Invalid end_date format');

    try {
      final permResult = await _calPlugin.requestPermissions();
      if (permResult.data != true) {
        return ToolResult.error(
          'Calendar permission denied. Please grant access in Settings.',
        );
      }

      final tzStart = tz.TZDateTime.from(startDate, tz.local);
      final tzEnd = tz.TZDateTime.from(
        endDate.add(const Duration(days: 1)),
        tz.local,
      );
      final params = RetrieveEventsParams(startDate: tzStart, endDate: tzEnd);

      // Collect events from all requested calendars.
      final List<Map<String, dynamic>> events = [];
      final calendarsResult = await _calPlugin.retrieveCalendars();
      final calendars = calendarsResult.data ?? [];

      for (final cal in calendars) {
        final id = cal.id;
        if (id == null) continue;
        if (calendarId != null && id != calendarId) continue;

        final eventsResult = await _calPlugin.retrieveEvents(id, params);
        for (final e in eventsResult.data ?? <Event>[]) {
          events.add({
            'id': e.eventId,
            'calendar_id': id,
            'calendar_name': cal.name,
            'title': e.title,
            'start': e.start?.toIso8601String(),
            'end': e.end?.toIso8601String(),
            'all_day': e.allDay,
            'location': e.location,
            'description': e.description,
          });
        }
      }

      events.sort((a, b) =>
          (a['start'] as String? ?? '').compareTo(b['start'] as String? ?? ''));

      if (events.isEmpty) {
        return ToolResult.success('No events found in the requested date range.');
      }
      return ToolResult.success(jsonEncode(events));
    } catch (e) {
      return ToolResult.error('Calendar error: $e');
    }
  }
}

/// Create a new calendar event.
class CalendarCreateEventTool extends Tool {
  @override
  String get name => 'calendar_create_event';

  @override
  String get description =>
      'Create a new event in the device calendar. '
      'If calendar_id is omitted, the default (first writable) calendar is used. '
      'Returns the ID of the created event.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'title': {'type': 'string', 'description': 'Event title.'},
          'start_date': {
            'type': 'string',
            'description': 'Event start (ISO 8601), e.g. "2025-03-14T10:00:00".',
          },
          'end_date': {
            'type': 'string',
            'description': 'Event end (ISO 8601), e.g. "2025-03-14T11:00:00".',
          },
          'calendar_id': {
            'type': 'string',
            'description': 'Target calendar ID (omit for default calendar).',
          },
          'location': {
            'type': 'string',
            'description': 'Optional event location.',
          },
          'description': {
            'type': 'string',
            'description': 'Optional event description/notes.',
          },
          'reminder_minutes': {
            'type': 'integer',
            'description': 'Minutes before event to trigger a reminder (e.g. 15).',
          },
        },
        'required': ['title', 'start_date', 'end_date'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final title = (args['title'] as String?)?.trim() ?? '';
    final startStr = (args['start_date'] as String?)?.trim() ?? '';
    final endStr = (args['end_date'] as String?)?.trim() ?? '';

    if (title.isEmpty) return ToolResult.error('title is required');
    if (startStr.isEmpty) return ToolResult.error('start_date is required');
    if (endStr.isEmpty) return ToolResult.error('end_date is required');

    final startDate = DateTime.tryParse(startStr);
    final endDate = DateTime.tryParse(endStr);
    if (startDate == null) return ToolResult.error('Invalid start_date format');
    if (endDate == null) return ToolResult.error('Invalid end_date format');

    try {
      final permResult = await _calPlugin.requestPermissions();
      if (permResult.data != true) {
        return ToolResult.error(
          'Calendar permission denied. Please grant access in Settings.',
        );
      }

      // Resolve calendar ID — use provided or find the first writable one.
      String? calId = (args['calendar_id'] as String?)?.trim();
      if (calId == null || calId.isEmpty) {
        final calendarsResult = await _calPlugin.retrieveCalendars();
        final writable = (calendarsResult.data ?? [])
            .where((c) => c.isReadOnly == false)
            .toList();
        if (writable.isEmpty) {
          return ToolResult.error('No writable calendar found on this device.');
        }
        calId = writable.first.id;
      }

      final event = Event(
        calId,
        title: title,
        start: tz.TZDateTime.from(startDate, tz.local),
        end: tz.TZDateTime.from(endDate, tz.local),
        location: (args['location'] as String?)?.trim(),
        description: (args['description'] as String?)?.trim(),
      );

      final reminderMin = (args['reminder_minutes'] as num?)?.toInt();
      if (reminderMin != null) {
        event.reminders = [Reminder(minutes: reminderMin)];
      }

      final result = await _calPlugin.createOrUpdateEvent(event);
      if (result?.isSuccess == true) {
        return ToolResult.success(
          'Event created. id=${result!.data}, title="$title", '
          'start=$startStr, end=$endStr',
        );
      }
      final errors = result!.errors.map((e) => e.errorMessage).join('; ');
      return ToolResult.error('Failed to create event: $errors');
    } catch (e) {
      return ToolResult.error('Calendar error: $e');
    }
  }
}
