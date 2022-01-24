import 'package:aliyun_oss_dart_sdk/src/common/utils/auth_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/string_utils.dart';

import 'credentials.dart';
import 'credentials_provider.dart';
import 'default_credentials.dart';

/// {@link SystemPropertiesCredentialsProvider} implementation that provides
/// credentials by looking at the <code>oss.accessKeyId</code> and
/// <code>oss.accessKeySecret</code> Java system properties.
class SystemPropertiesCredentialsProvider implements CredentialsProvider {
  @override
  void setCredentials(Credentials creds) {}

  @override
  Credentials getCredentials() {
    String? accessKeyId = StringUtils.trim(
        System.getProperty(AuthUtils.ACCESS_KEY_SYSTEM_PROPERTY));
    String? secretAccessKey = StringUtils.trim(
        System.getProperty(AuthUtils.SECRET_KEY_SYSTEM_PROPERTY));
    String? sessionToken = StringUtils.trim(
        System.getProperty(AuthUtils.SESSION_TOKEN_SYSTEM_PROPERTY));

    if (accessKeyId?.isEmpty ?? true) {
      throw InvalidCredentialsException(
          "Access key id should not be null or empty.");
    }
    if (secretAccessKey?.isEmpty ?? true) {
      throw InvalidCredentialsException(
          "Secret access key should not be null or empty.");
    }

    return DefaultCredentials(accessKeyId!, secretAccessKey!, sessionToken);
  }
}
