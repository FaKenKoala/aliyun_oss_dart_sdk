import 'package:aliyun_oss_dart_sdk/src/common/auth/credentials.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/request_signer.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/request_message.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/sign_version.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_headers.dart';

import 'sign_utils.dart';
import 'sign_v2_utils.dart';

class OSSRequestSigner implements RequestSigner {
  String httpMethod;

  /* Note that resource path should not have been url-encoded. */
  String resourcePath;

  Credentials creds;

  SignVersion signatureVersion;

  OSSRequestSigner(
      this.httpMethod, this.resourcePath, this.creds, this.signatureVersion);

  @override
  void sign(RequestMessage request) {
    String accessKeyId = creds.getAccessKeyId();
    String secretAccessKey = creds.getSecretAccessKey();

    if (accessKeyId.isNotEmpty && secretAccessKey.isNotEmpty) {
      String signature;

      if (signatureVersion == SignVersion.v2) {
        signature = SignV2Utils.buildSignature(
            secretAccessKey, httpMethod, resourcePath, request);
        request.addHeader(
            HttpHeaders.AUTHORIZATION,
            SignV2Utils.composeRequestAuthorization(
                accessKeyId, signature, request));
      } else {
        signature = SignUtils.buildSignature(
            secretAccessKey, httpMethod, resourcePath, request);
        request.addHeader(HttpHeaders.AUTHORIZATION,
            SignUtils.composeRequestAuthorization(accessKeyId, signature));
      }
    }
  }
}
