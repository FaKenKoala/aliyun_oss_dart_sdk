import 'package:aliyun_oss_dart_sdk/src/client_builder_configuration.dart';

import 'common/auth/credentials_provider.dart';
import 'common/auth/default_credential_provider.dart';
import 'oss_encryption_client.dart';

class OSSEncryptionClientBuilder {
  OSSEncryptionClient build(String endpoint,
      {String? accessKeyId,
      String? accessKeySecret,
      String? securityToken,
      CredentialsProvider? credsProvider,
      EncryptionMaterials? encryptionMaterials,
      ClientBuilderConfiguration? clientConfig,
      CryptoConfiguration? cryptoConfig}) 
      :assert(accessKeyId == null || accessKeySecret != null, "when accessKeyId is not null, accessKeySecret cannot be null too.")
      {
    return OSSEncryptionClient(
        endpoint,
        accessKeyId != null
            ? DefaultCredentialProvider(
                accessKeyId: accessKeyId,
                secretAccessKey: accessKeySecret!,
                securityToken: securityToken)
            : credsProvider,
        getClientConfiguration(clientConfig),
        encryptionMaterials,
        getCryptoConfiguration(cryptoConfig));
  }

  static ClientBuilderConfiguration getClientConfiguration(
      [ClientBuilderConfiguration? config]) {
    if (config == null) {
      config = ClientBuilderConfiguration();
    }
    return config;
  }

  static CryptoConfiguration getCryptoConfiguration(
      [CryptoConfiguration? cryptoConfig]) {
    if (cryptoConfig == null) {
      cryptoConfig = CryptoConfiguration.DEFAULT.clone();
    }
    return cryptoConfig;
  }
}
