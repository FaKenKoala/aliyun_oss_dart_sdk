import 'package:aliyun_oss_dart_sdk/src/client_builder_configuration.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/credentials_provider.dart';

abstract class OSSBuilder {
  OSS build({
    String? endpoint,
    String? accessKeyId,
    String? secretAccessKey,
    String? securityToken,
    CredentialsProvider? credsProvider,
    ClientBuilderConfiguration? config,
  });
}
