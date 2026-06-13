import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutterclaw/core/agent/agent_loop.dart';
import 'package:flutterclaw/core/agent/message_queue.dart';
import 'package:flutterclaw/core/providers/error_parser.dart';
import 'package:flutterclaw/core/providers/openai_provider.dart'
    show LlmProviderException;
import 'package:flutterclaw/core/utils/atomic_file.dart';

void main() {
  group('MessageQueue', () {
    test('serializes concurrent messages on same session', () async {
      final order = <int>[];
      final queue = MessageQueue(
        onRun: (message) async {
          final n = int.parse(message.text);
          order.add(n);
          await Future<void>.delayed(const Duration(milliseconds: 20));
          return AgentResponse(content: 'ok-$n', sessionKey: message.sessionKey);
        },
      );

      await queue.enqueueText(sessionKey: 's1', text: '1');
      await queue.enqueueText(sessionKey: 's1', text: '2');
      await queue.enqueueText(sessionKey: 's1', text: '3');

      expect(order, [1, 2, 3]);
    });
  });

  group('error_parser', () {
    test('classifies HTTP 400 and 413 as permanent', () {
      expect(
        parseLlmError(
          LlmProviderException(message: 'bad request', statusCode: 400),
        ).failoverReason,
        FailoverReason.invalidRequest,
      );
      expect(
        parseLlmError(
          LlmProviderException(message: 'too large', statusCode: 413),
        ).failoverReason,
        FailoverReason.invalidRequest,
      );
    });
  });

  group('atomic_file', () {
    test('recovers from corrupt json using backup', () async {
      final dir = await Directory.systemTemp.createTemp('flutterclaw_test_');
      final path = '${dir.path}/config.json';
      final good = {'version': 1, 'name': 'ok'};

      await writeAtomic(path, jsonEncode({'version': 0}));
      await writeAtomic(path, jsonEncode(good));
      await File(path).writeAsString('{ corrupt');

      final loaded = await readJsonWithBackup(path);
      expect(loaded?['version'], 0);

      await dir.delete(recursive: true);
    });
  });
}
