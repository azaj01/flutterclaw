import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

final _log = Logger('flutterclaw.security');

class SecurityService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const _gatewayTokenKey = 'gateway_token';
  static const _biometricEnabledKey = 'biometric_enabled';
  static const _apiKeyPrefix = 'api_key_';

  static Future<void> storeApiKey(String providerName, String apiKey) async {
    await _storage.write(key: '$_apiKeyPrefix$providerName', value: apiKey);
    _log.info('Stored API key for $providerName');
  }

  static Future<String?> getApiKey(String providerName) async {
    return _storage.read(key: '$_apiKeyPrefix$providerName');
  }

  static Future<void> deleteApiKey(String providerName) async {
    await _storage.delete(key: '$_apiKeyPrefix$providerName');
  }

  static Future<List<String>> listStoredProviders() async {
    final all = await _storage.readAll();
    return all.keys
        .where((k) => k.startsWith(_apiKeyPrefix))
        .map((k) => k.substring(_apiKeyPrefix.length))
        .toList();
  }

  static Future<void> setGatewayToken(String token) async {
    await _storage.write(key: _gatewayTokenKey, value: token);
  }

  static Future<String?> getGatewayToken() async {
    return _storage.read(key: _gatewayTokenKey);
  }

  static Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(
      key: _biometricEnabledKey,
      value: enabled ? 'true' : 'false',
    );
  }

  static Future<bool> isBiometricEnabled() async {
    final val = await _storage.read(key: _biometricEnabledKey);
    return val == 'true';
  }

  static String hashToken(String token) {
    return sha256.convert(utf8.encode(token)).toString();
  }

  static bool validateToken(String provided, String storedHash) {
    return hashToken(provided) == storedHash;
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
    _log.info('All secure storage cleared');
  }
}
