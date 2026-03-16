/// UI Automation tools — let the agent simulate user interaction on the device.
///
/// Android: full cross-app automation via AccessibilityService.
/// iOS: screenshot only (cross-app control is not available on iOS).
library;

import 'dart:convert';

import 'package:flutterclaw/services/ui_automation_service.dart';
import 'package:flutterclaw/tools/registry.dart';

// ─── Permission ───────────────────────────────────────────────────────────────

class UiCheckPermissionTool extends Tool {
  final UiAutomationService _svc;
  UiCheckPermissionTool(this._svc);

  @override
  String get name => 'ui_check_permission';

  @override
  String get description =>
      'Check whether UI automation is available on this device.\n\n'
      'Android: returns true if the Accessibility Service is enabled.\n'
      'iOS: always returns false — cross-app UI automation is not supported on iOS.\n\n'
      'If not granted on Android, call ui_request_permission to open '
      'Settings > Accessibility so the user can enable it.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {},
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final r = await _svc.checkPermission();
    return ToolResult.success(jsonEncode(r));
  }
}

// ─── Request permission ───────────────────────────────────────────────────────

class UiRequestPermissionTool extends Tool {
  final UiAutomationService _svc;
  UiRequestPermissionTool(this._svc);

  @override
  String get name => 'ui_request_permission';

  @override
  String get description =>
      'Open the system Accessibility Settings page so the user can enable '
      'UI automation for this app.\n\n'
      'Android only. Tell the user to find "FlutterClaw UI Automation" in the '
      'list and toggle it on. After they return, call ui_check_permission to '
      'confirm it is active.\n\n'
      'iOS: not applicable — returns an informational note.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {},
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final r = await _svc.requestPermission();
    if (r['error'] == true) return ToolResult.error(r['message'] as String? ?? 'Failed');
    return ToolResult.success(jsonEncode(r));
  }
}

// ─── Tap ──────────────────────────────────────────────────────────────────────

class UiTapTool extends Tool {
  final UiAutomationService _svc;
  UiTapTool(this._svc);

  @override
  String get name => 'ui_tap';

  @override
  String get description =>
      'Tap at screen coordinates (x, y) in pixels.\n\n'
      'Use ui_find_elements first to discover element positions, then pass '
      'the element\'s centerX/centerY directly here.\n\n'
      'Requires Accessibility Service (check with ui_check_permission).\n'
      'Android only.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'x': {'type': 'number', 'description': 'X coordinate in screen pixels.'},
          'y': {'type': 'number', 'description': 'Y coordinate in screen pixels.'},
        },
        'required': ['x', 'y'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final x = (args['x'] as num?)?.toDouble();
    final y = (args['y'] as num?)?.toDouble();
    if (x == null) return ToolResult.error('x is required');
    if (y == null) return ToolResult.error('y is required');

    final r = await _svc.tap(x, y);
    if (r['error'] == true) return ToolResult.error(r['message'] as String? ?? r['code'] as String? ?? 'Failed');
    return ToolResult.success(jsonEncode(r));
  }
}

// ─── Swipe ────────────────────────────────────────────────────────────────────

class UiSwipeTool extends Tool {
  final UiAutomationService _svc;
  UiSwipeTool(this._svc);

  @override
  String get name => 'ui_swipe';

  @override
  String get description =>
      'Swipe from (x1, y1) to (x2, y2) in screen pixels.\n\n'
      'Common patterns:\n'
      '- Scroll down: swipe from bottom-center to top-center\n'
      '- Scroll up: swipe from top-center to bottom-center\n'
      '- Dismiss notification: swipe right from element position\n\n'
      'duration_ms controls swipe speed (default 300ms). '
      'Shorter = faster flick, longer = slow drag.\n\n'
      'Requires Accessibility Service. Android only.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'x1': {'type': 'number', 'description': 'Start X in pixels.'},
          'y1': {'type': 'number', 'description': 'Start Y in pixels.'},
          'x2': {'type': 'number', 'description': 'End X in pixels.'},
          'y2': {'type': 'number', 'description': 'End Y in pixels.'},
          'duration_ms': {
            'type': 'integer',
            'description': 'Swipe duration in milliseconds (50–5000, default 300).',
            'minimum': 50,
            'maximum': 5000,
          },
        },
        'required': ['x1', 'y1', 'x2', 'y2'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final x1 = (args['x1'] as num?)?.toDouble();
    final y1 = (args['y1'] as num?)?.toDouble();
    final x2 = (args['x2'] as num?)?.toDouble();
    final y2 = (args['y2'] as num?)?.toDouble();
    if (x1 == null) return ToolResult.error('x1 is required');
    if (y1 == null) return ToolResult.error('y1 is required');
    if (x2 == null) return ToolResult.error('x2 is required');
    if (y2 == null) return ToolResult.error('y2 is required');
    final durationMs = (args['duration_ms'] as num?)?.toInt() ?? 300;

    final r = await _svc.swipe(x1, y1, x2, y2, durationMs: durationMs);
    if (r['error'] == true) return ToolResult.error(r['message'] as String? ?? r['code'] as String? ?? 'Failed');
    return ToolResult.success(jsonEncode(r));
  }
}

// ─── Type text ────────────────────────────────────────────────────────────────

class UiTypeTextTool extends Tool {
  final UiAutomationService _svc;
  UiTypeTextTool(this._svc);

  @override
  String get name => 'ui_type_text';

  @override
  String get description =>
      'Type text into the currently focused input field on screen.\n\n'
      'The field must already be focused (tapped). If no field is focused, '
      'use ui_tap on the input field first, then call ui_type_text.\n\n'
      'Replaces the current field content entirely.\n\n'
      'Requires Accessibility Service. Android only.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'text': {
            'type': 'string',
            'description': 'The text to type into the focused input field.',
          },
        },
        'required': ['text'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final text = args['text'] as String?;
    if (text == null || text.isEmpty) return ToolResult.error('text is required');

    final r = await _svc.typeText(text);
    if (r['error'] == true) return ToolResult.error(r['message'] as String? ?? r['code'] as String? ?? 'Failed');
    if (r['success'] == false) {
      return ToolResult.error(r['message'] as String? ?? 'Type text failed');
    }
    return ToolResult.success(jsonEncode(r));
  }
}

// ─── Find elements ────────────────────────────────────────────────────────────

class UiFindElementsTool extends Tool {
  final UiAutomationService _svc;
  UiFindElementsTool(this._svc);

  @override
  String get name => 'ui_find_elements';

  @override
  String get description =>
      'List interactive elements currently visible on screen.\n\n'
      'Each element includes: text, contentDescription, resourceId, className, '
      'bounds (left/top/right/bottom), centerX, centerY, isClickable, isEnabled.\n\n'
      'Use centerX/centerY directly as x/y in ui_tap.\n\n'
      'Parameters:\n'
      '- query: optional filter string\n'
      '- by: how to match — "all" (default), "text", "id", "description", "class"\n\n'
      'Examples:\n'
      '- Find all elements: {}\n'
      '- Find button by text: {"query": "Submit", "by": "text"}\n'
      '- Find by resource ID: {"query": "btn_login", "by": "id"}\n\n'
      'Results capped at 200 nodes. Requires Accessibility Service. Android only.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'query': {
            'type': 'string',
            'description': 'Optional search string to filter elements.',
          },
          'by': {
            'type': 'string',
            'enum': ['all', 'text', 'id', 'description', 'class'],
            'description': 'How to match the query (default: "all").',
          },
        },
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final query = args['query'] as String?;
    final by = (args['by'] as String?) ?? 'all';

    final r = await _svc.findElements(query: query, by: by);
    if (r['error'] == true) return ToolResult.error(r['message'] as String? ?? r['code'] as String? ?? 'Failed');
    return ToolResult.success(jsonEncode(r));
  }
}

// ─── Click element ────────────────────────────────────────────────────────────

class UiClickElementTool extends Tool {
  final UiAutomationService _svc;
  UiClickElementTool(this._svc);

  @override
  String get name => 'ui_click_element';

  @override
  String get description =>
      'Find an element by text, ID, or description and click it in one step.\n\n'
      'Prefer this over ui_find_elements + ui_tap when you know what to click.\n\n'
      'Parameters:\n'
      '- query: the string to search for (required)\n'
      '- by: "text" (default), "id", "description", "class"\n\n'
      'Returns the matched element\'s details on success.\n\n'
      'Requires Accessibility Service. Android only.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'query': {
            'type': 'string',
            'description': 'Text, resource ID, or content description to search for.',
          },
          'by': {
            'type': 'string',
            'enum': ['text', 'id', 'description', 'class'],
            'description': 'How to identify the element (default: "text").',
          },
        },
        'required': ['query'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final query = args['query'] as String?;
    if (query == null || query.isEmpty) return ToolResult.error('query is required');
    final by = (args['by'] as String?) ?? 'text';

    final r = await _svc.clickElement(query, by);
    if (r['error'] == true) return ToolResult.error(r['message'] as String? ?? r['code'] as String? ?? 'Failed');
    if (r['success'] == false) {
      return ToolResult.error(r['message'] as String? ?? 'Element not found or click failed');
    }
    return ToolResult.success(jsonEncode(r));
  }
}

// ─── Screenshot ───────────────────────────────────────────────────────────────

class UiScreenshotTool extends Tool {
  final UiAutomationService _svc;
  UiScreenshotTool(this._svc);

  @override
  String get name => 'ui_screenshot';

  @override
  String get description =>
      'Capture the current screen as a PNG image.\n\n'
      'Android: full-screen capture (all apps) when Accessibility Service is '
      'enabled and API >= 30; falls back to app-surface-only on older APIs.\n'
      'iOS: captures the FlutterClaw app surface only.\n\n'
      'Returns base64-encoded PNG. Pass the result to a vision model to '
      'understand what is currently on screen before deciding what to tap.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {},
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final r = await _svc.screenshot();
    if (r['error'] == true) return ToolResult.error(r['message'] as String? ?? r['code'] as String? ?? 'Screenshot failed');
    // Return in the image content block format used throughout FlutterClaw
    final output = {
      'type': 'image',
      'data': r['data'],
      'mimeType': r['mimeType'] ?? 'image/png',
      if (r['note'] != null) 'note': r['note'],
    };
    return ToolResult.success(jsonEncode(output));
  }
}

// ─── Global action ────────────────────────────────────────────────────────────

class UiGlobalActionTool extends Tool {
  final UiAutomationService _svc;
  UiGlobalActionTool(this._svc);

  @override
  String get name => 'ui_global_action';

  @override
  String get description =>
      'Perform a global device action.\n\n'
      'Available actions:\n'
      '- back: press the Back button\n'
      '- home: press the Home button\n'
      '- recents: open the Recents/Overview screen\n'
      '- notifications: pull down the notification shade\n'
      '- quick_settings: pull down Quick Settings\n\n'
      'Requires Accessibility Service. Android only.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'action': {
            'type': 'string',
            'enum': ['back', 'home', 'recents', 'notifications', 'quick_settings'],
            'description': 'The global action to perform.',
          },
        },
        'required': ['action'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final action = args['action'] as String?;
    if (action == null || action.isEmpty) return ToolResult.error('action is required');

    final r = await _svc.globalAction(action);
    if (r['error'] == true) return ToolResult.error(r['message'] as String? ?? r['code'] as String? ?? 'Failed');
    return ToolResult.success(jsonEncode(r));
  }
}
