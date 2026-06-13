/// Shared secure-storage wiring for [ConfigManager] in any isolate.
library;

import 'package:flutterclaw/data/models/config.dart';
import 'package:flutterclaw/services/secure_key_store.dart';

/// Wires [ConfigManager] to read/write secrets via the platform keychain.
void wireConfigSecrets(ConfigManager configManager) {
  configManager.secretsResolver = (ref_) => SecureKeyStore.getSecret(
        ref_.startsWith(r'{"$ref":"secrets/')
            ? ref_
                .substring(r'{"$ref":"secrets/'.length)
                .replaceAll('"}}', '')
                .replaceAll('"}', '')
            : ref_,
      );
  configManager.secretsWriter =
      (name, value) => SecureKeyStore.saveSecret(name, value);
}
