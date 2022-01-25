import 'oss_federation_token.dart';

const int int64MaxValue = 9223372036854775807;

abstract class OSSCredentialProvider {
  Future<OSSFederationToken?> getFederationToken();
}
