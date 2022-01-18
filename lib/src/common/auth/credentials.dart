/// Provides access to credentials used for accessing OSS, these credentials are
/// used to securely sign requests to OSS.
abstract class Credentials {
  /// Returns the access key ID for this credentials.
  String getAccessKeyId();

  /// Returns the secret access key for this credentials.
  String getSecretAccessKey();

  /// Returns the security token for this credentials.
  String? getSecurityToken();

  /// Determines whether to use security token for http requests.
  bool useSecurityToken();
}
