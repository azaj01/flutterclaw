/// Queries provider APIs to discover available models dynamically.
///
/// Supported providers:
/// - **Ollama** — GET /api/tags (cloud: with Bearer auth; local: no auth)
/// - **OpenRouter** — GET /api/v1/models (public, no auth needed)
/// - **OpenAI-compatible** — GET /v1/models (requires API key)
///
/// Results are merged with the static catalog; duplicates (matching id) are
/// skipped so the catalog's display names and metadata take precedence.
library;

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

import '../data/models/model_catalog.dart';

final _log = Logger('ModelDiscoveryService');

/// A discovered model from a provider API.
class DiscoveredModel {
  final String id;
  final String displayName;
  final String providerId;
  final bool isFree;
  final int contextWindow;
  final List<String> inputModalities;
  final double pricingPrompt;
  final double pricingCompletion;

  const DiscoveredModel({
    required this.id,
    required this.displayName,
    required this.providerId,
    this.isFree = false,
    this.contextWindow = 0,
    this.inputModalities = const ['text'],
    this.pricingPrompt = 0,
    this.pricingCompletion = 0,
  });

  /// Convert to a [CatalogModel] for display alongside static entries.
  CatalogModel toCatalogModel() => CatalogModel(
        id: id,
        displayName: displayName,
        providerId: providerId,
        isFree: isFree,
        contextWindow: contextWindow,
        input: inputModalities,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'providerId': providerId,
        'isFree': isFree,
        'contextWindow': contextWindow,
        'inputModalities': inputModalities,
        'pricingPrompt': pricingPrompt,
        'pricingCompletion': pricingCompletion,
      };

  factory DiscoveredModel.fromJson(Map<String, dynamic> json) =>
      DiscoveredModel(
        id: json['id'] as String,
        displayName: json['displayName'] as String,
        providerId: json['providerId'] as String? ?? 'openrouter',
        isFree: json['isFree'] as bool? ?? false,
        contextWindow: json['contextWindow'] as int? ?? 0,
        inputModalities:
            (json['inputModalities'] as List?)?.cast<String>() ?? const ['text'],
        pricingPrompt: (json['pricingPrompt'] as num?)?.toDouble() ?? 0,
        pricingCompletion: (json['pricingCompletion'] as num?)?.toDouble() ?? 0,
      );
}

class ModelDiscoveryService {
  final Dio _dio;

  ModelDiscoveryService({Dio? dio}) : _dio = dio ?? Dio();

  /// In-memory cache for OpenRouter models.
  List<DiscoveredModel>? _openRouterCache;
  DateTime? _openRouterCacheTime;

  static const _cacheTtl = Duration(hours: 1);
  static const _cacheFileName = 'openrouter_models.json';

  /// Returns the full OpenRouter model list with caching (memory + disk, 1h TTL).
  Future<List<DiscoveredModel>> getOpenRouterModels({
    String? apiKey,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh &&
        _openRouterCache != null &&
        _openRouterCacheTime != null &&
        DateTime.now().difference(_openRouterCacheTime!) < _cacheTtl) {
      return _openRouterCache!;
    }

    if (!forceRefresh) {
      final disk = await _readDiskCache();
      if (disk != null) {
        _openRouterCache = disk;
        _openRouterCacheTime = DateTime.now();
        return disk;
      }
    }

    final models = await _discoverOpenRouter(apiKey ?? '');
    if (models.isNotEmpty) {
      _openRouterCache = models;
      _openRouterCacheTime = DateTime.now();
      _writeDiskCache(models);
    }
    return models;
  }

  Future<List<DiscoveredModel>?> _readDiskCache() async {
    try {
      final dir = await getApplicationSupportDirectory();
      final file = File('${dir.path}/cache/$_cacheFileName');
      if (!file.existsSync()) return null;
      final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final ts = DateTime.tryParse(json['timestamp'] as String? ?? '');
      if (ts == null || DateTime.now().difference(ts) > _cacheTtl) return null;
      final list = (json['models'] as List)
          .map((m) => DiscoveredModel.fromJson(m as Map<String, dynamic>))
          .toList();
      return list;
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeDiskCache(List<DiscoveredModel> models) async {
    try {
      final dir = await getApplicationSupportDirectory();
      final cacheDir = Directory('${dir.path}/cache');
      if (!cacheDir.existsSync()) cacheDir.createSync(recursive: true);
      final file = File('${cacheDir.path}/$_cacheFileName');
      final payload = jsonEncode({
        'timestamp': DateTime.now().toIso8601String(),
        'models': models.map((m) => m.toJson()).toList(),
      });
      await file.writeAsString(payload);
    } catch (e) {
      _log.fine('Failed to write OpenRouter cache: $e');
    }
  }

  /// Discover available models for the given [providerId].
  ///
  /// [apiKey] — the user's API key (may be empty for Ollama).
  /// [apiBase] — override the default base URL (used for custom providers).
  ///
  /// Returns an empty list on any network or parse error (non-throwing).
  Future<List<DiscoveredModel>> discoverModels({
    required String providerId,
    required String apiKey,
    String? apiBase,
  }) async {
    try {
      switch (providerId) {
        case 'ollama':
          return await _discoverOllama(
            apiBase ?? 'https://ollama.com',
            apiKey: apiKey,
          );
        case 'openrouter':
          return await _discoverOpenRouter(apiKey);
        case 'anthropic':
          return await _discoverAnthropic(apiKey);
        case 'openai':
        case 'xai':
        case 'groq':
        case 'deepseek':
        case 'google':
        case 'custom':
          final base = apiBase ??
              ModelCatalog.getProvider(providerId)?.apiBase ??
              'https://api.openai.com/v1';
          return await _discoverOpenAiCompat(
            providerId: providerId,
            apiKey: apiKey,
            apiBase: base,
          );
        default:
          return [];
      }
    } catch (e) {
      _log.warning('Model discovery failed for $providerId: $e');
      return [];
    }
  }

  // -----------------------------------------------------------------------
  // Ollama — GET /api/tags  (cloud: Bearer auth; local: no auth)
  // -----------------------------------------------------------------------
  Future<List<DiscoveredModel>> _discoverOllama(String base, {String apiKey = ''}) async {
    // Strip /v1 suffix so the discovery URL always hits /api/tags correctly.
    final cleanBase = base.replaceAll(RegExp(r'/v1/?$'), '');
    final url = cleanBase.endsWith('/') ? '${cleanBase}api/tags' : '$cleanBase/api/tags';
    final headers = <String, dynamic>{};
    if (apiKey.isNotEmpty) headers['Authorization'] = 'Bearer $apiKey';
    final response = await _dio.get(
      url,
      options: Options(
        headers: headers,
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 5),
        validateStatus: (_) => true,
      ),
    );
    if ((response.statusCode ?? 0) != 200) return [];

    final models = response.data?['models'] as List? ?? [];
    return models.map((m) {
      final name = (m['name'] as String?) ?? '';
      return DiscoveredModel(
        id: name,
        displayName: name,
        providerId: 'ollama',
        isFree: true,
      );
    }).toList();
  }

  // -----------------------------------------------------------------------
  // OpenRouter — GET /api/v1/models  (no auth required for public list)
  // -----------------------------------------------------------------------
  Future<List<DiscoveredModel>> _discoverOpenRouter(String apiKey) async {
    final headers = <String, dynamic>{
      'HTTP-Referer': 'https://flutterclaw.ai',
    };
    if (apiKey.isNotEmpty) headers['Authorization'] = 'Bearer $apiKey';

    final response = await _dio.get(
      'https://openrouter.ai/api/v1/models',
      options: Options(
        headers: headers,
        receiveTimeout: const Duration(seconds: 15),
        validateStatus: (_) => true,
      ),
    );
    if ((response.statusCode ?? 0) != 200) return [];

    final data = response.data?['data'] as List? ?? [];
    return data.map((m) {
      final id = (m['id'] as String?) ?? '';
      final name = (m['name'] as String?) ?? id;
      final pricing = m['pricing'] as Map?;
      final promptPrice =
          double.tryParse('${pricing?['prompt'] ?? '1'}') ?? 1.0;
      final completionPrice =
          double.tryParse('${pricing?['completion'] ?? '1'}') ?? 1.0;
      final contextLen = (m['context_length'] as int?) ?? 0;
      final arch = m['architecture'] as Map?;
      final modalities =
          (arch?['input_modalities'] as List?)?.cast<String>() ?? const ['text'];
      return DiscoveredModel(
        id: id,
        displayName: name,
        providerId: 'openrouter',
        isFree: promptPrice == 0.0,
        contextWindow: contextLen,
        inputModalities: modalities,
        pricingPrompt: promptPrice * 1e6,
        pricingCompletion: completionPrice * 1e6,
      );
    }).toList();
  }

  // -----------------------------------------------------------------------
  // Anthropic — GET /v1/models  (requires x-api-key + anthropic-version)
  // -----------------------------------------------------------------------
  Future<List<DiscoveredModel>> _discoverAnthropic(String apiKey) async {
    if (apiKey.isEmpty) return [];

    final response = await _dio.get(
      'https://api.anthropic.com/v1/models?limit=100',
      options: Options(
        headers: {
          'x-api-key': apiKey,
          'anthropic-version': '2023-06-01',
        },
        receiveTimeout: const Duration(seconds: 10),
        validateStatus: (_) => true,
      ),
    );
    if ((response.statusCode ?? 0) != 200) return [];

    final data = response.data?['data'] as List? ?? [];
    return data.map((m) {
      final id = (m['id'] as String?) ?? '';
      final name = (m['display_name'] as String?) ?? id;
      return DiscoveredModel(
        id: id,
        displayName: name,
        providerId: 'anthropic',
      );
    }).toList();
  }

  // -----------------------------------------------------------------------
  // OpenAI-compatible GET /v1/models
  // -----------------------------------------------------------------------
  Future<List<DiscoveredModel>> _discoverOpenAiCompat({
    required String providerId,
    required String apiKey,
    required String apiBase,
  }) async {
    if (apiKey.isEmpty) return [];

    // Normalise base: remove trailing /openai suffix added for Gemini compat
    final normalised = apiBase.endsWith('/openai')
        ? apiBase.substring(0, apiBase.length - 7)
        : apiBase;
    final base = normalised.endsWith('/') ? normalised : '$normalised/';

    final response = await _dio.get(
      '${base}models',
      options: Options(
        headers: {'Authorization': 'Bearer $apiKey'},
        receiveTimeout: const Duration(seconds: 10),
        validateStatus: (_) => true,
      ),
    );
    if ((response.statusCode ?? 0) != 200) return [];

    final data = response.data?['data'] as List? ?? [];
    return data.map((m) {
      final id = (m['id'] as String?) ?? '';
      return DiscoveredModel(
        id: id,
        displayName: id,
        providerId: providerId,
      );
    }).toList();
  }
}
