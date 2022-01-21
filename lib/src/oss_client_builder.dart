import 'package:aliyun_oss_dart_sdk/src/common/auth/credentials_provider.dart';

import 'client_builder_configuration.dart';
import 'common/auth/default_credential_provider.dart';
import 'oss.dart';
import 'oss_builder.dart';
import 'oss_client.dart';

/// Fluent builder for OSS Client. Use of the builder is preferred over using
/// constructors of the client class.
class OSSClientBuilder implements OSSBuilder {

  @override
  OSS build(String endpoint, {String? accessKeyId, String? secretAccessKey,
      String? securityToken, ClientBuilderConfiguration? config, CredentialsProvider? credsProvider}) {
    return OSSClient(
        endpoint,
        credsProvider??getDefaultCredentialProvider(
            accessKeyId!, secretAccessKey!, securityToken),
        getClientConfiguration(config));
  }


  static ClientBuilderConfiguration getClientConfiguration(
      ClientBuilderConfiguration? config) {
    return config ?? ClientBuilderConfiguration();
  }

  static DefaultCredentialProvider getDefaultCredentialProvider(
      String accessKeyId, String secretAccessKey, String? securityToken) {
    return DefaultCredentialProvider(
        accessKeyId: accessKeyId,
        secretAccessKey: secretAccessKey,
        securityToken: securityToken);
  }
}
