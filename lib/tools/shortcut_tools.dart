library;

import 'dart:async';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../services/deep_link_service.dart';
import 'registry.dart';

const _uuid = Uuid();

// ---------------------------------------------------------------------------
// ShortcutToolsService — pending Completer registry
// ---------------------------------------------------------------------------

/// Holds in-flight Completers for [RunShortcutTool] calls.
class ShortcutToolsService {
  final _pending = <String, Completer<DeepLinkCallback>>{};

  Future<DeepLinkCallback> waitForCallback({
    required String runId,
    Duration timeout = const Duration(seconds: 30),
  }) {
    final completer = Completer<DeepLinkCallback>();
    _pending[runId] = completer;

    Future<void>.delayed(timeout).then((_) {
      final c = _pending.remove(runId);
      if (c != null && !c.isCompleted) {
        c.complete(DeepLinkCallback(
          runId: runId,
          status: 'timeout',
          rawUrl: '',
        ));
      }
    });

    return completer.future;
  }

  void resolve(DeepLinkCallback callback) {
    final completer = _pending.remove(callback.runId);
    if (completer != null && !completer.isCompleted) {
      completer.complete(callback);
    }
  }

  void listenToDeepLinks(DeepLinkService deepLinkService) {
    deepLinkService.callbacks.listen(resolve);
  }
}

// ---------------------------------------------------------------------------
// run_shortcut tool
// ---------------------------------------------------------------------------

class RunShortcutTool extends Tool {
  final ShortcutToolsService _service;

  RunShortcutTool({required ShortcutToolsService service}) : _service = service;

  @override
  String get name => 'run_shortcut';

  @override
  String get description =>
      'Run any iOS Shortcut by name and wait for its result.\n\n'
      'The shortcut receives the input as JSON; runId and callbackUrl are injected automatically. '
      'The shortcut should open the callbackUrl when done to return the result to the agent.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'name': {
            'type': 'string',
            'description': 'Exact shortcut name as it appears in the iOS Shortcuts app.',
          },
          'input': {
            'type': 'object',
            'description':
                'Parameters to pass to the shortcut as a JSON object. '
                'runId and callbackUrl are injected automatically.',
          },
          'timeout_seconds': {
            'type': 'integer',
            'minimum': 5,
            'maximum': 120,
            'description': 'Max seconds to wait for the callback (default: 30).',
          },
        },
        'required': ['name'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> args) async {
    final name = (args['name'] as String?)?.trim() ?? '';
    if (name.isEmpty) return ToolResult.error('name is required');

    final inputMap = (args['input'] as Map<String, dynamic>?) ?? {};
    final timeoutSecs =
        ((args['timeout_seconds'] as num?)?.toInt() ?? 30).clamp(5, 120);

    final runId = _uuid.v4();
    final callbackUrl = 'flutterclaw://callback?runId=$runId&status=success';
    final payload = Map<String, dynamic>.from(inputMap)
      ..['runId'] = runId
      ..['callbackUrl'] = callbackUrl;
    final inputJson = jsonEncode(payload);

    final callbackFuture = _service.waitForCallback(
      runId: runId,
      timeout: Duration(seconds: timeoutSecs),
    );

    final shortcutUrl = Uri(
      scheme: 'shortcuts',
      host: 'run-shortcut',
      queryParameters: {
        'name': name,
        'input': 'text',
        'text': inputJson,
      },
    );

    if (!await canLaunchUrl(shortcutUrl)) {
      _service.resolve(DeepLinkCallback(
        runId: runId,
        status: 'error',
        result: 'Cannot open Shortcuts app',
        rawUrl: '',
      ));
      return ToolResult.error(
        'Cannot open Shortcuts app. '
        'Ensure Shortcuts is installed and "$name" exists.',
      );
    }

    await launchUrl(shortcutUrl, mode: LaunchMode.externalApplication);

    final callback = await callbackFuture;

    return ToolResult.success(jsonEncode({
      'status': callback.status,
      if (callback.result != null) 'result': callback.result,
      'shortcut': name,
      'runId': runId,
    }));
  }
}
