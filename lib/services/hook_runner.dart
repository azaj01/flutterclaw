/// Hook system for intercepting agent lifecycle and tool execution events.
///
/// Mirrors OpenClaw's hook architecture: hooks fire on well-defined events,
/// can allow or block an operation, and can be registered either in code
/// (built-in hooks) or via workspace HOOKS.json files (user hooks).
library;

import 'package:logging/logging.dart';

final _log = Logger('flutterclaw.hooks');

/// Events that can trigger hooks.
enum HookEvent {
  /// Fires before a tool is executed. Returning [HookResult.block] prevents
  /// execution and returns an error to the LLM.
  preToolUse,

  /// Fires after a tool completes. Useful for logging or side-effects.
  /// Cannot block at this stage.
  postToolUse,

  /// Fires when a new agent session starts.
  sessionStart,

  /// Fires when an agent session finishes (turn complete).
  sessionStop,

  /// Fires before context compaction begins.
  preCompact,

  /// Fires after context compaction completes.
  postCompact,
}

/// Context passed to a hook when it fires.
class HookContext {
  /// The event that triggered this hook.
  final HookEvent event;

  /// Tool name (set for [HookEvent.preToolUse] and [HookEvent.postToolUse]).
  final String? toolName;

  /// Tool arguments (set for [HookEvent.preToolUse]).
  final Map<String, dynamic>? toolArgs;

  /// Tool result content (set for [HookEvent.postToolUse]).
  final String? toolResult;

  /// Whether the tool result was an error (set for [HookEvent.postToolUse]).
  final bool toolResultIsError;

  /// Session key for session-lifecycle events.
  final String? sessionKey;

  const HookContext({
    required this.event,
    this.toolName,
    this.toolArgs,
    this.toolResult,
    this.toolResultIsError = false,
    this.sessionKey,
  });
}

/// Result returned by a hook callback.
class HookResult {
  /// Whether the hook allows the operation to proceed.
  final bool allow;

  /// When [allow] is false, this message is shown to the LLM as the error
  /// reason. When [allow] is true, this is an optional informational message.
  final String? message;

  const HookResult.allow([this.message]) : allow = true;
  const HookResult.block(this.message) : allow = false;

  static const permitted = HookResult.allow();
}

/// A registered hook definition.
class HookDefinition {
  /// Unique name for this hook (used for logging).
  final String name;

  /// The event this hook fires on.
  final HookEvent event;

  /// Optional regex pattern to match tool names.
  /// Only relevant for [HookEvent.preToolUse] and [HookEvent.postToolUse].
  /// If null, the hook fires for ALL tools.
  final RegExp? toolMatcher;

  /// The callback to invoke. Must be fast (synchronous-equivalent).
  final Future<HookResult> Function(HookContext) callback;

  HookDefinition({
    required this.name,
    required this.event,
    this.toolMatcher,
    required this.callback,
  });

  /// Whether this hook applies to a given tool name.
  bool matchesTool(String toolName) {
    if (toolMatcher == null) return true;
    return toolMatcher!.hasMatch(toolName);
  }
}

/// Registry and runner for hooks.
///
/// Hooks are registered in priority order. For [HookEvent.preToolUse], the
/// first hook that returns [HookResult.block] terminates processing and the
/// operation is blocked. All [HookEvent.postToolUse] hooks run regardless of
/// their results.
class HookRunner {
  final _hooks = <HookDefinition>[];

  /// Register a hook. Hooks fire in registration order.
  void register(HookDefinition hook) {
    _hooks.add(hook);
    _log.fine('Registered hook: ${hook.name} (${hook.event.name})');
  }

  /// Remove a hook by name.
  void unregister(String name) {
    _hooks.removeWhere((h) => h.name == name);
  }

  /// Run all pre-tool-use hooks for a given tool.
  ///
  /// Returns [HookResult.permitted] if all hooks allow the call, or the
  /// first blocking [HookResult] encountered.
  Future<HookResult> runPreToolUse(
    String toolName,
    Map<String, dynamic> args,
  ) async {
    final ctx = HookContext(
      event: HookEvent.preToolUse,
      toolName: toolName,
      toolArgs: args,
    );
    return _runHooks(HookEvent.preToolUse, ctx, toolName: toolName);
  }

  /// Run all post-tool-use hooks. Errors are logged but never bubble.
  Future<void> runPostToolUse(
    String toolName,
    String result, {
    bool isError = false,
  }) async {
    final ctx = HookContext(
      event: HookEvent.postToolUse,
      toolName: toolName,
      toolResult: result,
      toolResultIsError: isError,
    );
    await _runHooks(HookEvent.postToolUse, ctx, toolName: toolName);
  }

  /// Run lifecycle hooks (sessionStart, sessionStop, preCompact, postCompact).
  Future<HookResult> runLifecycle(
    HookEvent event,
    String sessionKey,
  ) async {
    assert(event != HookEvent.preToolUse && event != HookEvent.postToolUse);
    final ctx = HookContext(event: event, sessionKey: sessionKey);
    return _runHooks(event, ctx);
  }

  Future<HookResult> _runHooks(
    HookEvent event,
    HookContext ctx, {
    String? toolName,
  }) async {
    final relevant = _hooks.where((h) {
      if (h.event != event) return false;
      if (toolName != null) return h.matchesTool(toolName);
      return true;
    });

    for (final hook in relevant) {
      try {
        final result = await hook.callback(ctx);
        if (!result.allow) {
          _log.info('Hook "${hook.name}" blocked ${event.name}'
              '${toolName != null ? ' ($toolName)' : ''}');
          return result;
        }
      } catch (e, st) {
        _log.warning('Hook "${hook.name}" threw: $e', e, st);
        // Errors in hooks never block the operation.
      }
    }
    return HookResult.permitted;
  }

  /// True if any hooks are registered for [event].
  bool hasHooksFor(HookEvent event) => _hooks.any((h) => h.event == event);
}
