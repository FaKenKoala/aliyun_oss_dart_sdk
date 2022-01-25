import 'package:encrypt/encrypt.dart';

import 'content_crypto_mode.dart';
import 'crypto_storage_method.dart';

/// The crypto configuration used to configure storage method of crypto info,
/// content crypto mode, secure random generator and content crypto provider.
class CryptoConfiguration {
  static final SecureRandom SRAND = SecureRandom();
  ContentCryptoMode contentCryptoMode;
  CryptoStorageMethod storageMethod;
  Provider contentCryptoProvider;
  SecureRandom secureRandom;

  /// Default crypto configuration.
  static final CryptoConfiguration DEFAULT = CryptoConfiguration();

  CryptoConfiguration(
      [this.contentCryptoMode = ContentCryptoMode.AES_CTR_MODE,
      this.storageMethod = CryptoStorageMethod.ObjectMetadata,
      this.secureRandom = SRAND,
      this.contentCryptoProvider]);

  CryptoConfiguration clone() {
    CryptoConfiguration config = CryptoConfiguration();
    config.contentCryptoMode = (contentCryptoMode);
    config.secureRandom = (secureRandom);
    config.storageMethod = (storageMethod);
    config.contentCryptoProvider = (contentCryptoProvider);
    return config;
  }
}
