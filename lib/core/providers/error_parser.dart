/// Parses LLM provider errors into user-friendly messages.
library;

import 'dart:ui' show PlatformDispatcher, Locale;

import 'package:dio/dio.dart';
import 'package:flutterclaw/core/providers/openai_provider.dart'
    show LlmProviderException;
import 'package:flutterclaw/generated/app_localizations.dart';

/// Resolves localized strings outside the widget tree using the device
/// locale, falling back to English for unsupported locales.
AppLocalizations get _l10n {
  try {
    return lookupAppLocalizations(PlatformDispatcher.instance.locale);
  } catch (_) {
    return lookupAppLocalizations(const Locale('en'));
  }
}

/// Classifies the failure reason so the router can decide whether to retry,
/// back off, or fail immediately.  Mirrors OpenClaw's `FailoverReason`.
enum FailoverReason {
  /// Transient — safe to retry with exponential backoff.
  rateLimited,
  /// Transient — provider overloaded, retry after brief delay.
  overloaded,
  /// Transient — network issue or unknown, may resolve on retry.
  networkError,
  /// Permanent — bad API key, don't retry.
  authFailed,
  /// Permanent — insufficient credits/quota, don't retry.
  billing,
  /// Permanent — model does not exist, don't retry.
  modelNotFound,
  /// Permanent — bad request or payload too large, don't retry.
  invalidRequest,
  /// Transient — request timed out, may succeed on retry.
  timeout,
  /// Transient — unknown error, can attempt retry.
  unknown,
}

class ParsedLlmError {
  final String friendlyMessage;
  final int? statusCode;
  /// When set, chat UI uses this as the error card title instead of mapping [statusCode].
  final String? errorTitle;
  /// Optional primary action (e.g. OpenRouter privacy settings).
  final String? ctaUrl;
  final String? ctaLabel;
  /// Failover classification used by [FailoverProviderRouter].
  final FailoverReason failoverReason;

  const ParsedLlmError({
    required this.friendlyMessage,
    this.statusCode,
    this.errorTitle,
    this.ctaUrl,
    this.ctaLabel,
    this.failoverReason = FailoverReason.unknown,
  });

  /// Whether this error is transient and safe to retry with backoff.
  bool get isTransient => switch (failoverReason) {
    FailoverReason.rateLimited => true,
    FailoverReason.overloaded => true,
    FailoverReason.networkError => true,
    FailoverReason.timeout => true,
    _ => false,
  };

  /// Whether this error is permanent — retrying will not help.
  bool get isPermanent => !isTransient;
}

/// Extracts a user-friendly message, status code, and failover reason
/// from a caught exception.
ParsedLlmError parseLlmError(Object e) {
  int? statusCode;
  String raw;

  if (e is LlmProviderException) {
    statusCode = e.statusCode;
    raw = e.message;
  } else if (e is DioException) {
    statusCode = e.response?.statusCode;
    raw = e.message ?? '';
  } else {
    raw = e.toString();
    final match =
        RegExp(r'status(?:\s*code)?\s*(?:of\s+)?(\d{3})').firstMatch(raw);
    if (match != null) {
      statusCode = int.tryParse(match.group(1)!);
    }
  }

  final reason = _classifyFailover(statusCode, raw);
  final mt = _messageAndTitle(statusCode, raw);
  return ParsedLlmError(
    friendlyMessage: mt.message,
    statusCode: statusCode,
    errorTitle: mt.title,
    ctaUrl: mt.ctaUrl,
    ctaLabel: mt.ctaLabel,
    failoverReason: reason,
  );
}

/// Classifies the error into a [FailoverReason] for retry logic.
FailoverReason _classifyFailover(int? statusCode, String raw) {
  final lower = raw.toLowerCase();
  switch (statusCode) {
    case 401:
    case 403:
      return FailoverReason.authFailed;
    case 402:
      return FailoverReason.billing;
    case 404:
      return FailoverReason.modelNotFound;
    case 400:
    case 413:
      return FailoverReason.invalidRequest;
    case 429:
      return FailoverReason.rateLimited;
    case 500:
    case 502:
    case 503:
    case 529:
      return FailoverReason.overloaded;
    default:
      if (lower.contains('timed out') || lower.contains('timeoutexception')) {
        return FailoverReason.timeout;
      }
      if (lower.contains('socketexception') ||
          lower.contains('connection refused') ||
          lower.contains('network')) {
        return FailoverReason.networkError;
      }
      return FailoverReason.unknown;
  }
}

/// OpenRouter returns HTTP 404 with a body like "No endpoints available… data policy…
/// Configure: https://openrouter.ai/settings/privacy" — not "model not found".
({
  String message,
  String? title,
  String? ctaUrl,
  String? ctaLabel,
}) _messageAndTitle(int? statusCode, String raw) {
  // HTTP 413: Payload Too Large (RFC 7231). OpenRouter/proxy may reject oversized
  // JSON bodies — long chat history, images/PDFs as base64, etc.
  // See https://openrouter.ai/docs/api/reference/errors-and-debugging
  if (statusCode == 413) {
    final l10n = _l10n;
    return (
      message: l10n.llmErrorPayloadTooLarge,
      title: l10n.llmErrorPayloadTooLargeTitle,
      ctaUrl: 'https://openrouter.ai/docs/api/reference/errors-and-debugging',
      ctaLabel: l10n.llmErrorViewDocs,
    );
  }

  final lower = raw.toLowerCase();
  if (lower.contains('guardrail') ||
      lower.contains('openrouter.ai/settings/privacy') ||
      (lower.contains('no endpoints available') &&
          (lower.contains('data policy') || lower.contains('policy')))) {
    final l10n = _l10n;
    return (
      message: l10n.llmErrorOpenRouterPrivacy,
      title: l10n.llmErrorOpenRouterPrivacyTitle,
      ctaUrl: 'https://openrouter.ai/settings/privacy',
      ctaLabel: l10n.llmErrorOpenPrivacySettings,
    );
  }
  return (
    message: _friendlyMessage(statusCode, raw),
    title: null,
    ctaUrl: null,
    ctaLabel: null,
  );
}

String _friendlyMessage(int? statusCode, String raw) {
  final l10n = _l10n;
  switch (statusCode) {
    case 401:
      return l10n.llmError401;
    case 402:
      return l10n.llmError402;
    case 403:
      return l10n.llmError403;
    case 404:
      return l10n.llmError404;
    case 413:
      return l10n.llmError413;
    case 429:
      return l10n.llmError429;
    case 500:
      return l10n.llmError500;
    case 502 || 503:
      return l10n.llmError503;
    case 529:
      return l10n.llmError529;
    case 400:
      return l10n.llmError400(raw);
    default:
      if (raw.contains('SocketException') ||
          raw.contains('Connection refused')) {
        return l10n.llmErrorNetwork;
      }
      if (raw.contains('timed out') || raw.contains('TimeoutException')) {
        return l10n.llmErrorTimeout;
      }
      if (statusCode != null) {
        return l10n.llmErrorWithStatus(statusCode, raw);
      }
      return l10n.llmErrorUnknown;
  }
}
