import 'oss_credential_provider.dart';
import 'oss_federation_token.dart';

class OSSStsTokenCredentialProvider implements OSSCredentialProvider {
  String accessKeyId;
  String secretKeyId;
  String securityToken;

  OSSStsTokenCredentialProvider(
      this.accessKeyId, this.secretKeyId, this.securityToken);

  factory OSSStsTokenCredentialProvider.fromTken(OSSFederationToken token) {
    return OSSStsTokenCredentialProvider(
        token.tempAK, token.tempSK, token.securityToken);
  }

  @override
  Future<OSSFederationToken> getFederationToken() async {
    return OSSFederationToken(
        accessKeyId, secretKeyId, securityToken, int64MaxValue);
  }
}
