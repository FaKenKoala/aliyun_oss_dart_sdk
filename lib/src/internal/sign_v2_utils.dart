import 'dart:convert';

import 'package:aliyun_oss_dart_sdk/src/client_configuration.dart';
import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/credentials.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/request_message.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/coding_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_headers.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_util.dart';
import 'package:aliyun_oss_dart_sdk/src/http_method.dart';
import 'package:aliyun_oss_dart_sdk/src/model/generate_presigned_url_request.dart';

import 'oss_constants.dart';
import 'oss_headers.dart';
import 'oss_utils.dart';
import 'request_parameters.dart';
import 'sign_parameters.dart';

class SignV2Utils {
  static String composeRequestAuthorization(
      String accessKeyId, String signature, RequestMessage request) {
    StringBuffer sb = StringBuffer();
    sb
      ..write(SignParameters.AUTHORIZATION_PREFIX_V2 +
          SignParameters.AUTHORIZATION_ACCESS_KEY_ID)
      ..write(":")
      ..write(accessKeyId)
      ..write(", ");

    String additionHeaderNameStr = buildSortedAdditionalHeaderNameStr(
        request.originalRequest.headers.keys.toSet(),
        request.originalRequest.additionalHeaderNames);

    if (additionHeaderNameStr.isNotEmpty) {
      sb
        ..write(SignParameters.AUTHORIZATION_ADDITIONAL_HEADERS)
        ..write(":")
        ..write(additionHeaderNameStr)
        ..write(", ");
    }
    sb
      ..write(SignParameters.AUTHORIZATION_SIGNATURE)
      ..write(":")
      ..write(signature);

    return sb.toString();
  }

  static String buildSortedAdditionalHeaderNameStr(
      Set<String> headerNames, Set<String> additionalHeaderNames) {
    Set<String> ts =
        buildSortedAdditionalHeaderNames(headerNames, additionalHeaderNames);
    StringBuffer sb = StringBuffer();
    String separator = "";

    for (String header in ts) {
      sb.write(separator);
      sb.write(header);
      separator = ";";
    }
    return sb.toString();
  }

  static Set<String> buildSortedAdditionalHeaderNames(
      Set<String>? headerNames, Set<String>? additionalHeaderNames) {
    Set<String> ts = {};

    if (headerNames != null && additionalHeaderNames != null) {
      for (String additionalHeaderName in additionalHeaderNames) {
        if (headerNames.contains(additionalHeaderName)) {
          ts.add(additionalHeaderName.toLowerCase());
        }
      }
    }
    return ts;
  }

  static Set<String> buildRawAdditionalHeaderNames(
      Set<String>? headerNames, Set<String>? additionalHeaderNames) {
    Set<String> hs = {};

    if (headerNames != null && additionalHeaderNames != null) {
      for (String additionalHeaderName in additionalHeaderNames) {
        if (headerNames.contains(additionalHeaderName)) {
          hs.add(additionalHeaderName);
        }
      }
    }
    return hs;
  }

  static String buildCanonicalString(String method, String resourcePath,
      RequestMessage request, Set<String> additionalHeaderNames) {
    StringBuffer canonicalString = StringBuffer();
    canonicalString
      ..write(method)
      ..write(SignParameters.NEW_LINE);
    Map<String, String> headers = request.headers;
    Map<String, String> fixedHeadersToSign = <String, String>{};
    Map<String, String> canonicalizedOssHeadersToSign = <String, String>{};

    headers.forEach((key, value) {
      if (key != null) {
        String lowerKey = key.toLowerCase();
        if ([
          HttpHeaders.CONTENT_TYPE.toLowerCase(),
          HttpHeaders.CONTENT_MD5.toLowerCase(),
          HttpHeaders.DATE.toLowerCase()
        ].contains(lowerKey)) {
          fixedHeadersToSign[lowerKey] = value.trim();
        } else if (lowerKey.startsWith(OSSHeaders.ossPrefix)) {
          canonicalizedOssHeadersToSign[lowerKey] = value.trim();
        }
      }
    });

    if (!fixedHeadersToSign
        .containsKey(HttpHeaders.CONTENT_TYPE.toLowerCase())) {
      fixedHeadersToSign[HttpHeaders.CONTENT_TYPE.toLowerCase()] = "";
    }
    if (!fixedHeadersToSign.containsKey(HttpHeaders.CONTENT_MD5.toLowerCase())) {
      fixedHeadersToSign[HttpHeaders.CONTENT_MD5.toLowerCase()] = "";
    }

    for (String additionalHeaderName in additionalHeaderNames) {
      if (headers.containsKey(additionalHeaderName)) {
        canonicalizedOssHeadersToSign[additionalHeaderName.toLowerCase()] =
            headers[additionalHeaderName]!.trim();
      }
    }

    // write fixed headers to sign to canonical string
    fixedHeadersToSign.forEach((key, value) {
      canonicalString.write(value);
      canonicalString.write(SignParameters.NEW_LINE);
    });
    // write canonicalized oss headers to sign to canonical string
    canonicalizedOssHeadersToSign.forEach((key, value) {
      canonicalString
        ..write(key)
        ..write(':')
        ..write(value)
        ..write(SignParameters.NEW_LINE);
    });

    // write additional header names
    Set<String> ts = {};
    for (String additionalHeaderName in additionalHeaderNames) {
      ts.add(additionalHeaderName.toLowerCase());
    }
    String separator = "";

    for (String additionalHeaderName in ts) {
      canonicalString
        ..write(separator)
        ..write(additionalHeaderName);
      separator = ";";
    }
    canonicalString.write(SignParameters.NEW_LINE);

    // write canonical resource to canonical string
    canonicalString
        .write(buildCanonicalizedResource(resourcePath, request.parameters));

    return canonicalString.toString();
  }

  static String buildSignedURL(GeneratePresignedUrlRequest request,
      Credentials currentCreds, ClientConfiguration config, Uri endpoint) {
    String bucketName = request.bucketName;
    String accessId = currentCreds.getAccessKeyId();
    String accessKey = currentCreds.getSecretAccessKey();
    bool useSecurityToken = currentCreds.useSecurityToken();
    HttpMethod method = request.getMethod() ?? HttpMethod.get;

    String expires =
        ((request.expiration?.millisecondsSinceEpoch ?? 0) / 1000).toString();
    String key = request.key;
    String resourcePath =
        OSSUtils.determineResourcePath(bucketName, key, config.sldEnabled);

    RequestMessage requestMessage = RequestMessage(bucketName, key);
    requestMessage.endpoint =
        OSSUtils.determineFinalEndpoint(endpoint, bucketName, config);
    requestMessage.method = method;
    requestMessage.resourcePath = resourcePath;
    requestMessage.headers = request.headers;

    requestMessage.addHeader(HttpHeaders.DATE, expires);
    if (request.contentType?.trim().isNotEmpty ?? false) {
      requestMessage.addHeader(HttpHeaders.CONTENT_TYPE, request.contentType!);
    }
    if (request.contentMD5?.trim().isNotEmpty ?? false) {
      requestMessage.addHeader(HttpHeaders.CONTENT_MD5, request.contentMD5!);
    }

    request.userMetadata.forEach((key, value) {
      requestMessage.addHeader(OSSHeaders.ossUserMetadataPrefix + key, value);
    });

    Map<String, String> responseHeaderParams = <String, String>{};
    OSSUtils.populateResponseHeaderParameters(
        responseHeaderParams, request.responseHeaders);
    if (responseHeaderParams.isNotEmpty) {
      requestMessage.parameters = responseHeaderParams;
    }

    request.queryParam.forEach((key, value) {
      requestMessage.addParameter(key, value);
    });

    if (request.process?.trim().isNotEmpty ?? false) {
      requestMessage.addParameter(
          RequestParameters.SUBRESOURCE_PROCESS, request.process!);
    }

    if (useSecurityToken) {
      requestMessage.addParameter(
          RequestParameters.SECURITY_TOKEN, currentCreds.getSecurityToken()!);
    }

    String canonicalResource = "/" +
        ((bucketName != null) ? bucketName : "") +
        ((key != null ? "/" + key : ""));
    requestMessage.addParameter(RequestParameters.OSS_SIGNATURE_VERSION,
        SignParameters.AUTHORIZATION_V2);
    requestMessage.addParameter(RequestParameters.OSS_EXPIRES, expires);
    requestMessage.addParameter(
        RequestParameters.OSS_ACCESS_KEY_ID_PARAM, accessId);
    String additionalHeaderNameStr = buildSortedAdditionalHeaderNameStr(
        requestMessage.headers.keys.toSet(), request.additionalHeaderNames);

    if (additionalHeaderNameStr.isNotEmpty) {
      requestMessage.addParameter(
          RequestParameters.OSS_ADDITIONAL_HEADERS, additionalHeaderNameStr);
    }
    Set<String> rawAdditionalHeaderNames = buildRawAdditionalHeaderNames(
        request.headers.keys.toSet(), request.additionalHeaderNames);
    String canonicalString = buildCanonicalString(method.toString(),
        canonicalResource, requestMessage, rawAdditionalHeaderNames);
    String signature =
        HmacSHA256Signature().computeSignature(accessKey, canonicalString);

    Map<String, String> params = <String, String>{};

    if (additionalHeaderNameStr.isNotEmpty) {
      params[RequestParameters.OSS_ADDITIONAL_HEADERS] =
          additionalHeaderNameStr;
    }
    params[RequestParameters.OSS_SIGNATURE] = signature;
    params.addAll(requestMessage.parameters);

    String queryString =
        HttpUtil.paramToQueryString(params, OSSConstants.DEFAULT_CHARSET_NAME) ?? '';

    /* Compose HTTP request uri. */
    String url = requestMessage.endpoint.toString();
    if (!url.endsWith("/")) {
      url += "/";
    }
    url += resourcePath + "?" + queryString;
    return url;
  }

  static String buildCanonicalizedResource(
      String resourcePath, Map<String, String?> parameters) {
    CodingUtils.assertTrue(resourcePath.startsWith("/"),
        "Resource path should start with slash character");

    StringBuffer builder = StringBuffer();
    builder.write(uriEncoding(resourcePath));

    Map<String, String?> canonicalizedParams = <String, String?>{};

    parameters.forEach((key, value) {
      if (value != null) {
        canonicalizedParams[uriEncoding(key)] = uriEncoding(value);
      } else {
        canonicalizedParams[uriEncoding(key)] = null;
      }
    });

    String separator = '?';

    canonicalizedParams.forEach((key, value) {
      builder.write(separator);
      builder.write(key);
      if (value?.isNotEmpty ?? false) {
        builder
          ..write("=")
          ..write(value!);
      }
      separator = '&';
    });

    return builder.toString();
  }

  static String uriEncoding(String uri) {
    String result = "";

    bool lessT(int code, String standard) {
      return code <= standard.codeUnitAt(0);
    }

    bool greatT(int code, String standard) {
      return code >= standard.codeUnitAt(0);
    }

    try {
      for (int i = 0; i < uri.length; i++) {
        String c = uri.substring(i, i + 1);
        int code = uri.codeUnitAt(i);

        if ((greatT(code, 'A') && lessT(code, 'Z')) ||
            (greatT(code, 'a') && lessT(code, 'z')) ||
            (greatT(code, '0') && lessT(code, '9')) ||
            c == '_' ||
            c == '-' ||
            c == '~' ||
            c == '.') {
          result += c;
        } else if (c == '/') {
          result += "%2F";
        } else {
          List<int> b = utf8.encode(c);

          for (int i = 0; i < b.length; i++) {
            int k = b[i];

            if (k < 0) {
              k += 256;
            }
            result += "%" + k.toRadixString(16).toUpperCase();
          }
        }
      }
    } on UnsupportedError catch (e) {
      throw ClientException(e);
    }
    return result;
  }

  static String buildSignature(String secretAccessKey, String httpMethod,
      String resourcePath, RequestMessage request) {
    String canonicalString = buildCanonicalString(
        httpMethod,
        resourcePath,
        request,
        buildRawAdditionalHeaderNames(
            request.originalRequest.headers.keys.toSet(),
            request.originalRequest.additionalHeaderNames));
    return HmacSHA256Signature()
        .computeSignature(secretAccessKey, canonicalString);
  }
}
