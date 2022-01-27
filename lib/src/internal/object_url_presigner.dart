import 'package:aliyun_oss_dart_sdk/src/client_configuration.dart';
import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/oss_credential_provider.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/oss_custom_signer_credential_provider.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/oss_federation_credential_provider.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/oss_federation_token.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/oss_plain_text_aksk_credential_provider.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/oss_sts_token_credential_provider.dart';
import 'package:aliyun_oss_dart_sdk/src/common/http_method.dart';
import 'package:aliyun_oss_dart_sdk/src/common/oss_log.dart';
import 'package:aliyun_oss_dart_sdk/src/common/request_parameters.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/date_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/extension_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_headers.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/oss_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/model/generate_presigned_url_request.dart';
import 'request_message.dart';

class ObjectURLPresigner {
  Uri endpoint;
  OSSCredentialProvider credentialProvider;
  ClientConfiguration conf;

  ObjectURLPresigner(this.endpoint, this.credentialProvider, this.conf);

  Future<String> presignConstrainedURLWithRequest(
      GeneratePresignedUrlRequest request) async {
    String bucketName = request.bucketName;
    String objectKey = request.key;
    String expires =
        (DateUtil.getFixedSkewedTimeMillis() ~/ 1000 + request.expiration).toString();
    HttpMethod method = request.method;

    RequestMessage requestMessage = RequestMessage()
      ..endpoint = endpoint
      ..method = method
      ..bucketName = bucketName
      ..objectKey = objectKey;

    requestMessage.headers[HttpHeaders.date] = expires;

    if (request.contentType != null && request.contentType!.trim().isNotEmpty) {
      requestMessage.headers[HttpHeaders.contentType] = request.contentType!;
    }
    if (request.contentMD5 != null && request.contentMD5!.trim().isNotEmpty) {
      requestMessage.headers[HttpHeaders.contentMd5] = request.contentMD5!;
    }

    request.queryParameter.forEach((key, value) {
      requestMessage.parameters[key] = value;
    });
    //process img
    if (request.process != null && request.process!.trim().isNotEmpty) {
      requestMessage.parameters[RequestParameters.xOSSProcess] =
          request.process!;
    }

    OSSFederationToken? token;

    if (credentialProvider is OSSFederationCredentialProvider) {
      token = await (credentialProvider as OSSFederationCredentialProvider)
          .getValidFederationToken();
      if (token == null) {
        throw OSSClientException("Can not get a federation token!");
      }
      requestMessage.parameters[RequestParameters.securityToken] =
          token.securityToken;
    } else if (credentialProvider is OSSStsTokenCredentialProvider) {
      token = await credentialProvider.getFederationToken();
      requestMessage.parameters[RequestParameters.securityToken] =
          token!.securityToken;
    }

    String contentToSign = OSSUtils.buildCanonicalString(requestMessage);

    String signature;

    if (credentialProvider is OSSFederationCredentialProvider ||
        credentialProvider is OSSStsTokenCredentialProvider) {
      signature = OSSUtils.sign(token!.tempAK, token.tempSK, contentToSign);
    } else if (credentialProvider is OSSPlainTextAKSKCredentialProvider) {
      signature = OSSUtils.sign(
          (credentialProvider as OSSPlainTextAKSKCredentialProvider)
              .accessKeyId,
          (credentialProvider as OSSPlainTextAKSKCredentialProvider)
              .accessKeySecret,
          contentToSign);
    } else if (credentialProvider is OSSCustomSignerCredentialProvider) {
      signature = (credentialProvider as OSSCustomSignerCredentialProvider)
          .signContent(contentToSign);
    } else {
      throw OSSClientException("Unknown credentialProvider!");
    }

    String accessKey = signature.split(":")[0].substring(4);
    signature = signature.split(":")[1];

    String host = buildCanonicalHost(endpoint, bucketName, conf);

    Map<String, String> params = <String, String>{};
    params[HttpHeaders.expires] = expires;
    params[RequestParameters.ossAccessKeyId] = accessKey;
    params[RequestParameters.signature] = signature;
    params.addAll(requestMessage.parameters);
    String queryString = HttpUtil.paramToQueryString(params)!;

    String url = endpoint.scheme +
        "://" +
        host +
        "/" +
        HttpUtil.urlEncode(objectKey) +
        "?" +
        queryString;

    return url;
  }

  Future<String> presignConstrainedURL(
      String bucketName, String objectKey, int expiredTimeInSeconds) {
    GeneratePresignedUrlRequest presignedUrlRequest =
        GeneratePresignedUrlRequest(bucketName, objectKey);
    presignedUrlRequest.expiration = expiredTimeInSeconds;
    return presignConstrainedURLWithRequest(presignedUrlRequest);
  }

  String presignURL(String bucketName, String objectKey) {
    String host = buildCanonicalHost(endpoint, bucketName, conf);
    return endpoint.scheme + "://" + host + "/" + HttpUtil.urlEncode(objectKey);
  }

  String buildCanonicalHost(
      Uri endpoint, String bucketName, ClientConfiguration config) {
    String originHost = endpoint.host;
    String? portString;
    String path = endpoint.path;

    int port = endpoint.port;
    if (port != -1) {
      portString = port.toString();
    }

    bool isPathStyle = false;

    String host = originHost;
    if (portString.notNullOrEmpty) {
      host += ":$portString";
    }

    if (bucketName.notNullOrEmpty) {
      if (OSSUtils.isOssOriginHost(originHost)) {
        // official endpoint
        host = bucketName + "." + originHost;
      } else if (OSSUtils.isInCustomCnameExcludeList(
          originHost, config.customCnameExcludeList)) {
        if (config.pathStyleAccessEnable) {
          isPathStyle = true;
        } else {
          host = bucketName + "." + originHost;
        }
      } else {
        try {
          if (OSSUtils.isValidateIP(originHost)) {
            // ip address
            isPathStyle = true;
          }
        } catch (e) {
          OSSLog.logError('$e');
        }
      }
    }

    if (config.customPathPrefixEnable && path != null) {
      host += path;
    }

    if (isPathStyle) {
      host += ("/" + bucketName);
    }

    return host;
  }
}
