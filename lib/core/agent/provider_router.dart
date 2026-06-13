/// Abstract router for LLM provider selection with failover support.
library;

import 'dart:async';

import 'package:flutterclaw/core/providers/anthropic_provider.dart';
import 'package:flutterclaw/core/providers/bedrock_provider.dart';
import 'package:flutterclaw/core/providers/error_parser.dart';
import 'package:flutterclaw/core/providers/openai_provider.dart';
import 'package:flutterclaw/core/providers/provider_interface.dart';
import 'package:flutterclaw/data/models/config.dart';
import 'package:logging/logging.dart';

final _log = Logger('flutterclaw.provider_router');

/// Emitted when a model is confirmed unavailable (404 / model_not_found).
class ModelUnavailableEvent {
  final String modelId;
  final String modelName;
  final String provider;
  final DateTime timestamp;

  ModelUnavailableEvent({
    required this.modelId,
    required this.modelName,
    required this.provider,
  }) : timestamp = DateTime.now();
}

abstract class ProviderRouter {
  Future<LlmResponse> chatCompletion(LlmRequest request);
  Stream<LlmStreamEvent> chatCompletionStream(LlmRequest request);
}

class SimpleProviderRouter implements ProviderRouter {
  final LlmProvider provider;

  SimpleProviderRouter(this.provider);

  @override
  Future<LlmResponse> chatCompletion(LlmRequest request) =>
      provider.chatCompletion(request);

  @override
  Stream<LlmStreamEvent> chatCompletionStream(LlmRequest request) =>
      provider.chatCompletionStream(request);
}

/// Selects the correct [LlmProvider] implementation based on the request's
/// API base URL. Anthropic uses a different API format from all other
/// OpenAI-compatible providers (different endpoint, auth header, body).
LlmProvider _resolveProvider(LlmRequest request) {
  final base = request.apiBase.toLowerCase();
  if (base.contains('anthropic.com')) {
    return AnthropicProvider();
  }
  if (base.contains('bedrock-runtime')) {
    return BedrockProvider();
  }
  return OpenAiProvider();
}

/// Provider router with automatic retry (exponential backoff) for transient
/// errors and optional fallback to configured secondary models.
///
/// Retry policy (mirrors OpenClaw `failover-policy.ts`):
///   • Transient (429, 529, 5xx, timeout, network): up to 3 attempts with
///     1 s → 2 s → 4 s backoff.
///   • Permanent (401, 402, 403, 404): fail immediately, no retry.
class FailoverProviderRouter implements ProviderRouter {
  final LlmProvider primary;
  final List<LlmProvider> fallbacks;
  final ConfigManager configManager;

  static const _maxRetries = 3;
  static const _baseDelayMs = 1000;

  final _modelUnavailableCtl =
      StreamController<ModelUnavailableEvent>.broadcast();

  /// Stream of events when a model is confirmed unavailable.
  Stream<ModelUnavailableEvent> get modelUnavailableEvents =>
      _modelUnavailableCtl.stream;

  final _retryCtl = StreamController<int>.broadcast();

  /// Emits the attempt number (1-based) each time a transient error triggers
  /// a silent retry, so the UI can surface "retrying…" feedback.
  Stream<int> get retryEvents => _retryCtl.stream;

  FailoverProviderRouter({
    required this.primary,
    this.fallbacks = const [],
    required this.configManager,
  });

  @override
  Future<LlmResponse> chatCompletion(LlmRequest request) async {
    Object? lastError;

    for (var attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        return await _resolveProvider(request).chatCompletion(request);
      } catch (e) {
        lastError = e;
        final parsed = parseLlmError(e);

        if (parsed.isPermanent) {
          // No point retrying auth/billing/model-not-found errors.
          _log.warning(
            'Permanent error (${parsed.failoverReason.name}), '
            'skipping retry: ${parsed.friendlyMessage}',
          );
          break;
        }

        if (attempt < _maxRetries - 1) {
          final delayMs = _baseDelayMs * (1 << attempt); // 1s, 2s, 4s
          _log.warning(
            'Transient error (${parsed.failoverReason.name}) on attempt '
            '${attempt + 1}/$_maxRetries — retrying in ${delayMs}ms',
          );
          _retryCtl.add(attempt + 1);
          await Future<void>.delayed(Duration(milliseconds: delayMs));
        }
      }
    }

    // Emit unavailability event if the failure was model-not-found.
    if (lastError != null) {
      final parsed = parseLlmError(lastError);
      if (parsed.failoverReason == FailoverReason.modelNotFound) {
        _modelUnavailableCtl.add(ModelUnavailableEvent(
          modelId: request.model,
          modelName: request.model,
          provider: request.apiBase,
        ));
      }
    }

    // Primary exhausted — try configured fallback models if any
    _log.warning('Primary model failed after $_maxRetries attempts, trying fallbacks...');
    return _tryFallbacks(request, lastError!);
  }

  @override
  Stream<LlmStreamEvent> chatCompletionStream(LlmRequest request) async* {
    Object? lastError;

    for (var attempt = 0; attempt < _maxRetries; attempt++) {
      var emitted = false;
      try {
        await for (final event
            in _resolveProvider(request).chatCompletionStream(request)) {
          emitted = true;
          yield event;
        }
        return;
      } catch (e) {
        lastError = e;
        // Once content has been emitted we cannot safely restart the stream
        // (the consumer already saw partial output) — propagate the error.
        if (emitted) rethrow;

        final parsed = parseLlmError(e);
        if (parsed.isPermanent) {
          _log.warning(
            'Permanent stream error (${parsed.failoverReason.name}), '
            'skipping retry: ${parsed.friendlyMessage}',
          );
          rethrow;
        }

        if (attempt < _maxRetries - 1) {
          final delayMs = _baseDelayMs * (1 << attempt); // 1s, 2s, 4s
          _log.warning(
            'Transient stream error (${parsed.failoverReason.name}) on '
            'attempt ${attempt + 1}/$_maxRetries — retrying in ${delayMs}ms',
          );
          _retryCtl.add(attempt + 1);
          await Future<void>.delayed(Duration(milliseconds: delayMs));
        }
      }
    }

    yield* _tryFallbackStream(request, lastError!);
  }

  Stream<LlmStreamEvent> _tryFallbackStream(
    LlmRequest request,
    Object primaryError,
  ) async* {
    final config = configManager.config;
    if (config.modelList.length <= 1) throw primaryError;

    for (var i = 1; i < config.modelList.length; i++) {
      final fallbackModel = config.modelList[i];
      _log.info('Trying fallback stream model: ${fallbackModel.modelName}');
      final fallbackRequest = request.copyWith(
        model: fallbackModel.model,
        apiKey: config.resolveApiKey(fallbackModel),
        apiBase: config.resolveApiBase(fallbackModel),
      );
      try {
        await for (final event
            in _resolveProvider(fallbackRequest).chatCompletionStream(
          fallbackRequest,
        )) {
          yield event;
        }
        return;
      } catch (e) {
        _log.warning('Fallback stream ${fallbackModel.modelName} failed: $e');
      }
    }
    throw primaryError;
  }

  Future<LlmResponse> _tryFallbacks(LlmRequest request, Object primaryError) async {
    final config = configManager.config;
    final models = config.modelList;
    if (models.length <= 1) throw primaryError;

    for (var i = 1; i < models.length; i++) {
      final fallbackModel = models[i];
      _log.info('Trying fallback model: ${fallbackModel.modelName}');

      try {
        final fallbackRequest = request.copyWith(
          model: fallbackModel.model,
          apiKey: config.resolveApiKey(fallbackModel),
          apiBase: config.resolveApiBase(fallbackModel),
        );
        return await _resolveProvider(fallbackRequest).chatCompletion(fallbackRequest);
      } catch (e) {
        final parsed = parseLlmError(e);
        _log.warning(
          'Fallback ${fallbackModel.modelName} failed '
          '(${parsed.failoverReason.name}): ${parsed.friendlyMessage}',
        );
      }
    }

    throw primaryError;
  }
}
