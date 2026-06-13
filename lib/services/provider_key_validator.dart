import 'package:dio/dio.dart';

/// Validates provider API keys against their live endpoints.
///
/// Mirrors the onboarding validation flow (`auth_page.dart`) so the settings
/// screens can offer a "Test connection" action. Returns `null` on success,
/// or a short human-readable error description on failure.
class ProviderKeyValidator {
  ProviderKeyValidator._();

  static final _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Future<String?> validate({
    required String providerId,
    required String apiKey,
    String? apiBase,
    String? awsRegion,
    String? awsAuthMode,
  }) async {
    // Local Ollama and custom endpoints may legitimately have no key.
    final allowEmptyKey = providerId == 'ollama' || providerId == 'custom';
    if (apiKey.isEmpty && !allowEmptyKey) return 'API key is empty';

    try {
      switch (providerId) {
        case 'anthropic':
          return await _check(
            'https://api.anthropic.com/v1/models?limit=1',
            headers: {
              'x-api-key': apiKey,
              'anthropic-version': '2023-06-01',
            },
          );
        case 'openrouter':
          final base = _norm(apiBase ?? 'https://openrouter.ai/api/v1');
          final res = await _dio.get(
            '${base}auth/key',
            options: Options(
              headers: {
                'Authorization': 'Bearer $apiKey',
                'HTTP-Referer': 'https://flutterclaw.ai',
              },
              validateStatus: (_) => true,
            ),
          );
          final data = res.data;
          if (res.statusCode == 200 && data is Map && data['data'] != null) {
            return null;
          }
          return 'Invalid API key';
        case 'bedrock':
          if (awsAuthMode == 'sigv4') {
            // SigV4 request signing is not supported by this lightweight check.
            return null;
          }
          final region =
              (awsRegion == null || awsRegion.isEmpty) ? 'us-east-1' : awsRegion;
          return await _check(
            'https://bedrock.$region.amazonaws.com/foundation-models',
            headers: {'Authorization': 'Bearer $apiKey'},
          );
        default:
          final base = _norm(apiBase ?? 'https://api.openai.com/v1');
          return await _check(
            '${base}models',
            headers: {if (apiKey.isNotEmpty) 'Authorization': 'Bearer $apiKey'},
          );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return 'Request timed out';
      }
      return e.message ?? 'Connection error';
    } catch (e) {
      return e.toString();
    }
  }

  static String _norm(String base) => base.endsWith('/') ? base : '$base/';

  static Future<String?> _check(
    String url, {
    required Map<String, String> headers,
  }) async {
    final res = await _dio.get(
      url,
      options: Options(headers: headers, validateStatus: (_) => true),
    );
    final status = res.statusCode ?? 0;
    if (status >= 200 && status < 300) return null;
    if (status == 401 || status == 403) return 'Invalid API key';
    final data = res.data;
    if (data is Map && data['error'] is Map) {
      final msg = (data['error'] as Map)['message'];
      if (msg != null) return '$msg';
    }
    return 'HTTP $status';
  }
}
