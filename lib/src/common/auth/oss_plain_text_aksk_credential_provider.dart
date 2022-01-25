import 'oss_credential_provider.dart';
import 'oss_federation_token.dart';

@Deprecated('不建议在客户端使用')
class OSSPlainTextAKSKCredentialProvider implements OSSCredentialProvider {
  String accessKeyId;
  String accessKeySecret;

  OSSPlainTextAKSKCredentialProvider(this.accessKeyId, this.accessKeySecret);

  @override
  Future<OSSFederationToken?> getFederationToken() async {
    return null;
  }
}
