import 'package:aliyun_oss_dart_sdk/src/client_builder_configuration.dart';

import 'common/auth/credentials_provider.dart';
import 'common/auth/default_credential_provider.dart';
import 'crypto/crypto_configuration.dart';
import 'crypto/encryption_materials.dart';
import 'oss_encryption_client.dart';

class OSSEncryptionClientBuilder {
  OSSEncryptionClient build(
    String endpoint, {
    String? accessKeyId,
    String? accessKeySecret,
    String? securityToken,
    CredentialsProvider? credsProvider,
    EncryptionMaterials? encryptionMaterials,
    ClientBuilderConfiguration? clientConfig,
    CryptoConfiguration? cryptoConfig,
  }) {
    assert(accessKeyId == null || accessKeySecret != null,
        "when accessKeyId is not null, accessKeySecret cannot be null too.");

    return OSSEncryptionClient(
        endpoint,
        credsProvider ??
            DefaultCredentialProvider(
                accessKeyId: accessKeyId!,
                secretAccessKey: accessKeySecret!,
                securityToken: securityToken),
        getClientConfiguration(clientConfig),
        encryptionMaterials!,
        getCryptoConfiguration(cryptoConfig));
  }

  static ClientBuilderConfiguration getClientConfiguration(
      [ClientBuilderConfiguration? config]) {
    return config ?? ClientBuilderConfiguration();
  }

  static CryptoConfiguration getCryptoConfiguration(
      [CryptoConfiguration? cryptoConfig]) {
    cryptoConfig ??= CryptoConfiguration.DEFAULT.clone();
    return cryptoConfig;
  }
}
