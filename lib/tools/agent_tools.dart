import 'dart:async';
import 'dart:convert';
import 'package:flutterclaw/core/agent/subagent_registry.dart';
import 'package:flutterclaw/core/agent/session_manager.dart';
import 'package:flutterclaw/tools/registry.dart';
import 'package:flutterclaw/data/models/config.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Lists all available agents in the system.
/// Returns agent ID, name, emoji, model, and online status.
class AgentsListTool extends Tool {
  final ConfigManager configManager;

  AgentsListTool({required this.configManager});

  @override
  String get name => 'agents_list';

  @override
  String get description =>
      'List all available agents in the system. Returns agent ID, name, emoji, '
      'model, and online status. Use this to discover other agents before messaging them.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {},
        'required': [],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    try {
      final config = configManager.config;
      final agents = config.agentProfiles;
      final activeAgentId = config.activeAgentId;

      final result = agents.map((agent) {
        return {
          'id': agent.id,
          'name': agent.name,
          'emoji': agent.emoji,
          'model': agent.modelName,
          'status': agent.id == activeAgentId ? 'active' : 'idle',
          'vibe': agent.vibe,
        };
      }).toList();

      final response = jsonEncode({
        'success': true,
        'agents': result,
        'total': result.length,
      });

      return ToolResult.success(response);
    } catch (e) {
      return ToolResult.error('Failed to list agents: $e');
    }
  }
}

/// Sends a message to another agent asynchronously (non-blocking).
///
/// Dispatches the task to the target agent's session via [SubagentRegistry],
/// exactly like sessions_spawn. The reply arrives as a new message in the
/// caller's session — the user's conversation is never blocked.
class AgentSendTool extends Tool {
  final ConfigManager configManager;
  final SubagentLoopProxy loopProxy;
  final SubagentRegistry registry;
  final String Function() parentSessionKeyGetter;
  final Function(String sourceId, String targetId, String message) sendMessageCallback;

  AgentSendTool({
    required this.configManager,
    required this.loopProxy,
    required this.registry,
    required this.parentSessionKeyGetter,
    required this.sendMessageCallback,
  });

  @override
  String get name => 'agent_send';

  @override
  String get description =>
      'Send a message to another agent. Non-blocking: returns immediately and the '
      'target agent\'s reply arrives as a new message in your session when ready. '
      'Use agents_list to discover available agent IDs.\n\n'
      'Parameters:\n'
      '- target_agent_id (required): The ID of the agent to send the message to\n'
      '- message (required): The message content to send\n'
      '- label (optional): Short label to identify this exchange in completion events';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'target_agent_id': {
            'type': 'string',
            'description': 'The ID of the target agent to send the message to',
          },
          'message': {
            'type': 'string',
            'description': 'The message content to send to the target agent',
          },
          'label': {
            'type': 'string',
            'description': 'Short human-readable label shown in the completion event',
          },
        },
        'required': ['target_agent_id', 'message'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    try {
      final targetAgentId = arguments['target_agent_id'] as String?;
      final message = arguments['message'] as String?;
      final label = (arguments['label'] as String?)?.trim() ?? '';

      if (targetAgentId == null || targetAgentId.isEmpty) {
        return ToolResult.error('target_agent_id is required');
      }
      if (message == null || message.isEmpty) {
        return ToolResult.error('message is required');
      }

      final config = configManager.config;
      final sourceAgent = config.activeAgent;
      if (sourceAgent == null) {
        return ToolResult.error('No active agent found');
      }

      final targetAgent = config.agentProfiles
          .where((a) => a.id == targetAgentId)
          .firstOrNull;
      if (targetAgent == null) {
        return ToolResult.error('Target agent not found: $targetAgentId');
      }

      final parentKey = parentSessionKeyGetter();
      final shortId = _uuid.v4().substring(0, 8);
      // Use 'agent:<targetId>:<shortId>' so AgentLoop loads target's identity
      final childSessionKey = 'agent:$targetAgentId:$shortId';
      final runId = _uuid.v4();
      final displayLabel =
          label.isNotEmpty ? label : '${targetAgent.name}:$shortId';

      final run = SubagentRun(
        runId: runId,
        sessionKey: childSessionKey,
        label: displayLabel,
        parentSessionKey: parentKey,
      );
      registry.register(run);

      // Dispatch the task in the background — non-blocking.
      unawaited(Future(() async {
        try {
          if (run.cancelToken.isCancelled) {
            registry.complete(run.runId, error: 'Cancelled before start');
            return;
          }
          final result =
              await loopProxy.processMessage(childSessionKey, message.trim());
          if (run.cancelToken.isCancelled) {
            registry.complete(run.runId, error: 'Killed');
            return;
          }
          registry.complete(run.runId, result: result);
        } catch (e) {
          registry.complete(run.runId, error: e.toString());
        }
      }));

      return ToolResult.success(jsonEncode({
        'status': 'accepted',
        'runId': runId,
        'childSessionKey': childSessionKey,
        'from': {'id': sourceAgent.id, 'name': sourceAgent.name},
        'to': {'id': targetAgent.id, 'name': targetAgent.name},
        'note':
            'Message dispatched to ${targetAgent.name}. '
            'Their reply will arrive as a new message in your session. '
            'Call sessions_yield to end your turn and wait.',
      }));
    } catch (e) {
      return ToolResult.error('Failed to send message: $e');
    }
  }
}

/// Checks for incoming messages from other agents.
/// Returns pending messages that other agents have sent to you.
class AgentMessagesTool extends Tool {
  final ConfigManager configManager;
  final Function(String agentId) getMessagesCallback;

  AgentMessagesTool({
    required this.configManager,
    required this.getMessagesCallback,
  });

  @override
  String get name => 'agent_messages';

  @override
  String get description =>
      'Check for incoming messages from other agents. Returns pending messages '
      'that other agents have sent to you. Messages are retrieved from inter-agent sessions.';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'mark_as_read': {
            'type': 'boolean',
            'description': 'Whether to mark messages as read (not implemented yet)',
            'default': false,
          },
        },
        'required': [],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    try {
      final config = configManager.config;
      final activeAgent = config.activeAgent;

      if (activeAgent == null) {
        return ToolResult.error('No active agent found');
      }

      // Get messages via callback
      final messages = await getMessagesCallback(activeAgent.id);

      final response = jsonEncode({
        'success': true,
        'messages': messages,
        'count': (messages as List).length,
      });

      return ToolResult.success(response);
    } catch (e) {
      return ToolResult.error('Failed to retrieve messages: $e');
    }
  }
}

/// Sends a message to any session identified by its session key and waits for
/// the agent's response.
///
/// Ports OpenClaw's sessions_send tool. Unlike [AgentSendTool] (which targets
/// by agent profile ID), this tool targets by session key — making it usable
/// for both configured agents and dynamically spawned subagents.
class SessionsSendTool extends Tool {
  final SubagentLoopProxy loopProxy;
  final SessionManager sessionManager;
  final String Function() currentSessionKeyGetter;

  SessionsSendTool({
    required this.loopProxy,
    required this.sessionManager,
    required this.currentSessionKeyGetter,
  });

  @override
  String get name => 'sessions_send';

  @override
  String get description =>
      'Send a message to another session and wait for its response. '
      'Use sessionKey to target a specific session (e.g. a spawned subagent). '
      'Returns the agent\'s reply text.\n\n'
      'Parameters:\n'
      '- sessionKey (required): The session key to send the message to\n'
      '- message (required): The message to deliver\n'
      '- timeoutSeconds (optional): Max seconds to wait for a response (default 60, 0 = fire-and-forget)';

  @override
  Map<String, dynamic> get parameters => {
        'type': 'object',
        'properties': {
          'sessionKey': {
            'type': 'string',
            'description': 'The session key of the target session',
          },
          'message': {
            'type': 'string',
            'description': 'The message to send',
          },
          'timeoutSeconds': {
            'type': 'number',
            'minimum': 0,
            'description':
                'Seconds to wait for a reply (default 60; 0 = fire-and-forget)',
          },
        },
        'required': ['sessionKey', 'message'],
      };

  @override
  Future<ToolResult> execute(Map<String, dynamic> arguments) async {
    final sessionKey = (arguments['sessionKey'] as String?)?.trim() ?? '';
    final message = (arguments['message'] as String?)?.trim() ?? '';
    final timeoutRaw = arguments['timeoutSeconds'];
    final timeoutSeconds =
        timeoutRaw is num ? timeoutRaw.toInt().clamp(0, 3600) : 60;

    if (sessionKey.isEmpty) {
      return ToolResult.error('sessionKey is required');
    }
    if (message.isEmpty) {
      return ToolResult.error('message is required');
    }
    // Prevent sending to yourself
    if (sessionKey == currentSessionKeyGetter()) {
      return ToolResult.error(
          'Cannot send to your own session. Use sessions_spawn to start a new subagent.');
    }

    try {
      if (timeoutSeconds == 0) {
        // Fire-and-forget: do not await
        loopProxy.processMessage(sessionKey, message).ignore();
        return ToolResult.success(jsonEncode({
          'status': 'accepted',
          'sessionKey': sessionKey,
          'note': 'Message delivered (fire-and-forget, not waiting for reply).',
        }));
      }

      final reply = await loopProxy
          .processMessage(sessionKey, message)
          .timeout(Duration(seconds: timeoutSeconds),
              onTimeout: () => '[timeout after ${timeoutSeconds}s]');

      return ToolResult.success(jsonEncode({
        'status': 'ok',
        'sessionKey': sessionKey,
        'reply': reply,
      }));
    } catch (e) {
      return ToolResult.error('sessions_send failed: $e');
    }
  }
}
