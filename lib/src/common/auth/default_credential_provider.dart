import 'package:aliyun_oss_dart_sdk/src/common/auth/credentials.dart';

import 'credentials_provider.dart';
import 'default_credentials.dart';

/// Default implementation of {@link CredentialsProvider}.
class DefaultCredentialProvider implements CredentialsProvider {
  late Credentials creds;

  DefaultCredentialProvider(
      {String accessKeyId = "",
      String secretAccessKey = "",
      String? securityToken,
      Credentials? creds}) {
    setCredentials(creds ??
        DefaultCredentials(accessKeyId, secretAccessKey, securityToken));
  }

  @override
  void setCredentials(Credentials creds) {
    // checkCredentials(creds.getAccessKeyId(), creds.getSecretAccessKey());
    this.creds = creds;
  }

  @override
  Credentials getCredentials() {
    return creds;
  }

  //  static void checkCredentials(String? accessKeyId, String? secretAccessKey) {
  //     if (accessKeyId == null || accessKeyId!.equals("")) {
  //         throw new InvalidCredentialsException("Access key id should not be null or empty.");
  //     }

  //     if (secretAccessKey == null || secretAccessKey.equals("")) {
  //         throw new InvalidCredentialsException("Secret access key should not be null or empty.");
  //     }
  // }

}
