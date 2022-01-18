import 'credentials.dart';

/// Default implementation of {@link Credentials}.
class DefaultCredentials implements Credentials {
  DefaultCredentials(this.accessKeyId, this.secretAccessKey,
      [this.securityToken]);

  final String accessKeyId;
  final String secretAccessKey;
  final String? securityToken;

  @override
  String getAccessKeyId() {
    return accessKeyId;
  }

  @override
  String getSecretAccessKey() {
    return secretAccessKey;
  }

  @override
  String? getSecurityToken() {
    return securityToken;
  }

  @override
  bool useSecurityToken() {
    return securityToken != null;
  }
}
