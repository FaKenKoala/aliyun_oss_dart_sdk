import 'credentials.dart';

/// Abstract credentials provider that maintains only one user credentials. Users
/// can switch to other valid credentials with
/// {@link com.aliyun.oss.OSS#switchCredentials(com.aliyun.oss.common.auth.Credentials)} Note
/// that <b>implementations of this interface must be thread-safe.</b>
///
abstract class CredentialsProvider {
  void setCredentials(Credentials creds);

  Credentials getCredentials();
}
