import 'oss_credential_provider.dart';
import 'oss_federation_token.dart';

abstract class OSSCustomSignerCredentialProvider
    implements OSSCredentialProvider {
  /// Custom content sign method. Considering the AccessKeyId/AccessKeySecret is not likely be stored in mobile device,
  /// this method is supposed to talk to customer's app servers and get the signature of the content.
  /// The typical implementation could be that it posts the content to an app servers and the server has the AK information
  /// and sign the content then return the signature.
  /// <p>
  /// The sign algorithm：http://help.aliyun.com/document_detail/oss/api-reference/access-control/signature-header.html
  /// signature = "OSS " + AccessKeyId + ":" + base64(hmac-sha1(AccessKeySecret, content))
  /// <p>
  /// <p>
  /// content is the final text to sign which comes from the URL parameters, headers and the actual content payload.
  ///
  /// @param content The final text to sign, which is concated from url parameters, url headers and body.
  /// @return "OSS " + AccessKeyId + ":" + base64(hmac-sha1(AccessKeySecret, content))
  String signContent(String content);

  @override
  Future<OSSFederationToken?> getFederationToken() async {
    return null;
  }
}
