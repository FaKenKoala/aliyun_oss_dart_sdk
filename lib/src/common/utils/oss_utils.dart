import 'dart:collection';
import 'dart:convert';

import 'package:mime/mime.dart' as mime;

import 'package:aliyun_oss_dart_sdk/src/common/lib_common.dart';
import 'package:aliyun_oss_dart_sdk/src/exception/inconsistent_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/exception/oss_ioexception.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/lib_internal.dart';
import 'package:aliyun_oss_dart_sdk/src/model/lib_model.dart';

class OSSUtils {
  static final String _newLine = "\n";

  static final List<String> signedParameters = [
    RequestParameters.subresourceBucketinfo,
    RequestParameters.subresourceAcl,
    RequestParameters.subresourceUploads,
    RequestParameters.subresourceLocation,
    RequestParameters.subresourceCors,
    RequestParameters.subresourceLogging,
    RequestParameters.subresourceWebsite,
    RequestParameters.subresourceReferer,
    RequestParameters.subresourceLifecycle,
    RequestParameters.subresourceDelete,
    RequestParameters.subresourceAppend,
    RequestParameters.uploadId,
    RequestParameters.partNumber,
    RequestParameters.securityToken,
    RequestParameters.position,
    RequestParameters.responseHeaderCacheControl,
    RequestParameters.responseHeaderContentDisposition,
    RequestParameters.responseHeaderContentEncoding,
    RequestParameters.responseHeaderContentLanguage,
    RequestParameters.responseHeaderContentType,
    RequestParameters.responseHeaderExpires,
    RequestParameters.xOSSProcess,
    RequestParameters.subresourceSequential,
    RequestParameters.xOSSSymlink,
    RequestParameters.xOSSRestore,
  ];

  /// Populate metadata to headers.
  static void populateRequestMetadata(
      Map<String, String> headers, ObjectMetadata? metadata) {
    if (metadata == null) {
      return;
    }

    Map<String, Object?> rawMetadata = metadata.getRawMetadata();
    rawMetadata.forEach((key, value) {
      headers[key] = value.toString();
    });

    Map<String, String> userMetadata = metadata.getUserMetadata();
    userMetadata.forEach((key, value) {
      headers[key.trim()] = value.trim();
    });
  }

  static void populateListBucketRequestParameters(
      ListBucketsRequest listBucketsRequest, Map<String, String> params) {
    listBucketsRequest.prefix
        .apply((str) => params[RequestParameters.prefix] = str);

    listBucketsRequest.marker
        .apply((str) => params[RequestParameters.marker] = str);

    listBucketsRequest.maxKeys
        .apply((str) => params[RequestParameters.maxKeys] = str.toString());
  }

  static void populateListObjectsRequestParameters(
      ListObjectsRequest listObjectsRequest, Map<String, String> params) {
    listObjectsRequest.prefix
        .apply((str) => params[RequestParameters.prefix] = str);

    listObjectsRequest.marker
        .apply((str) => params[RequestParameters.marker] = str);

    listObjectsRequest.delimiter
        .apply((str) => params[RequestParameters.delimiter] = str);

    listObjectsRequest.maxKeys
        .apply((str) => params[RequestParameters.maxKeys] = str.toString());

    listObjectsRequest.encodingType
        .apply((str) => params[RequestParameters.encodingType] = str);
  }

  static void populateListMultipartUploadsRequestParameters(
      ListMultipartUploadsRequest request, Map<String, String> params) {
    request.delimiter.apply((str) => params[RequestParameters.delimiter] = str);

    request.maxUploads
        .apply((str) => params[RequestParameters.maxUploads] = str.toString());

    request.keyMarker.apply((str) => params[RequestParameters.keyMarker] = str);

    request.prefix.apply((str) => params[RequestParameters.prefix] = str);

    request.uploadIdMarker
        .apply((str) => params[RequestParameters.uploadIdMarker] = str);

    request.encodingType
        .apply((str) => params[RequestParameters.encodingType] = str);
  }

  static bool checkParamRange(
      int param, int from, bool leftInclusive, int to, bool rightInclusive) {
    if (leftInclusive && rightInclusive) {
      // [from, to]
      if (from <= param && param <= to) {
        return true;
      } else {
        return false;
      }
    } else if (leftInclusive && !rightInclusive) {
      // [from, to)
      if (from <= param && param < to) {
        return true;
      } else {
        return false;
      }
    } else if (!leftInclusive && !rightInclusive) {
      // (from, to)
      if (from < param && param < to) {
        return true;
      } else {
        return false;
      }
    } else {
      // (from, to]
      if (from < param && param <= to) {
        return true;
      } else {
        return false;
      }
    }
  }

  static void populateCopyObjectHeaders(
      CopyObjectRequest copyObjectRequest, Map<String, String> headers) {
    String copySourceHeader = "/" +
        copyObjectRequest.sourceBucketName +
        "/" +
        HttpUtil.urlEncode(copyObjectRequest.sourceKey);
    headers[OSSHeaders.copyObjectSource] = copySourceHeader;

    addDateHeader(headers, OSSHeaders.copyObjectSourceIfModifiedSince,
        copyObjectRequest.modifiedSinceConstraint);
    addDateHeader(headers, OSSHeaders.copyObjectSourceIfUnmodifiedSince,
        copyObjectRequest.unmodifiedSinceConstraint);

    addStringListHeader(headers, OSSHeaders.copyObjectSourceIfMatch,
        copyObjectRequest.getMatchingETagConstraints());
    addStringListHeader(headers, OSSHeaders.copyObjectSourceIfNoneMatch,
        copyObjectRequest.getNonmatchingEtagConstraints());

    addHeader(headers, OSSHeaders.ossServerSideEncryption,
        copyObjectRequest.serverSideEncryption);

    ObjectMetadata? newObjectMetadata = copyObjectRequest.newObjectMetadata;
    if (newObjectMetadata != null) {
      headers[OSSHeaders.copyObjectMetadataDirective] =
          MetadataDirective.REPLACE.toString();
      populateRequestMetadata(headers, newObjectMetadata);
    }

    // The header of Content-Length should not be specified on copying an object.
    removeHeader(headers, HttpHeaders.contentLength);
  }

  static String buildXMLFromPartEtagList(List<PartETag> partETagList) {
    StringBuffer builder = StringBuffer();
    builder.write("<CompleteMultipartUpload>\n");
    for (PartETag partETag in partETagList) {
      builder.write("<Part>\n");
      builder.write("<PartNumber>" '${partETag.partNumber}' "</PartNumber>\n");
      builder.write("<ETag>" + partETag.eTag + "</ETag>\n");
      builder.write("</Part>\n");
    }
    builder.write("</CompleteMultipartUpload>\n");
    return builder.toString();
  }

  static void addHeader(
      Map<String, String> headers, String header, String? value) {
    if (value != null) {
      headers[header] = value;
    }
  }

  static void addDateHeader(
      Map<String, String> headers, String header, DateTime? value) {
    if (value != null) {
      headers[header] = DateUtil.formatRfc822Date(value);
    }
  }

  static void addStringListHeader(
      Map<String, String> headers, String header, List<String>? values) {
    if (values != null && values.isNotEmpty) {
      headers[header] = join(values);
    }
  }

  static void removeHeader(Map<String, String> headers, String? header) {
    if (header != null && headers.containsKey(header)) {
      headers.remove(header);
    }
  }

  static String join(List<String> strings) {
    StringBuffer result = StringBuffer();

    bool first = true;
    for (String s in strings) {
      if (!first) result.write(", ");

      result.write(s);
      first = false;
    }

    return result.toString();
  }

  static String buildCanonicalString(RequestMessage request) {
    StringBuffer canonicalString = StringBuffer();
    canonicalString
      ..write(request.method.toString().toUpperCase())
      ..write(_newLine);

    Map<String, String> headers = request.headers;

    /// oss需要将相关的header排序
    SplayTreeMap<String, String> headersToSign =
        SplayTreeMap<String, String>.from({
      HttpHeaders.contentType: '',
      HttpHeaders.contentMd5: '',
    });

    final headerList = [
      HttpHeaders.contentType,
      HttpHeaders.contentMd5,
      HttpHeaders.date
    ];

    headers.forEach((key, value) {
      String lowerKey = key.toLowerCase();

      if (headerList.contains(lowerKey) ||
          lowerKey.startsWith(OSSHeaders.ossPrefix)) {
        headersToSign[lowerKey] = value.trim();
      }
    });

    // Append all headers to sign to canonical string
    headersToSign.forEach((key, value) {
      if (key.startsWith(OSSHeaders.ossPrefix)) {
        canonicalString
          ..write(key)
          ..write(':')
          ..write(value);
      } else {
        canonicalString.write(value);
      }
      canonicalString.write(_newLine);
    });

    // Append canonical resource to canonical string
    canonicalString.write(buildCanonicalizedResource(
        request.bucketName, request.objectKey, request.parameters));

    return canonicalString.toString();
  }

  static String buildCanonicalizedResource(
      String? bucketName, String? objectKey, Map<String, String>? parameters) {
    String resourcePath;
    if (bucketName == null && objectKey == null) {
      resourcePath = "/";
    } else if (objectKey == null) {
      resourcePath = "/$bucketName/";
    } else {
      resourcePath = "/$bucketName/$objectKey";
    }

    return buildCanonicalizedResourceWithPath(resourcePath, parameters);
  }

  static String buildCanonicalizedResourceWithPath(
      String resourcePath, Map<String, String>? parameters) {
    StringBuffer builder = StringBuffer();
    builder.write(resourcePath);

    if (parameters != null) {
      List<String> parameterNames = parameters.keys.toList()..sort();

      String separater = '?';
      for (String paramName in parameterNames) {
        if (!signedParameters.contains(paramName)) {
          continue;
        }

        builder.write(separater);
        builder.write(paramName);
        String? paramValue = parameters[paramName];
        if (paramValue.notNullOrEmpty) {
          builder
            ..write("=")
            ..write(paramValue);
        }

        separater = '&';
      }
    }

    return builder.toString();
  }

  /// Encode request parameters to URL segment.
  static String? paramToQueryString(Map<String, String>? params) {
    if (params == null || params.isEmpty) {
      return null;
    }

    StringBuffer paramString = StringBuffer();
    bool first = true;
    params.forEach((key, value) {
      if (!first) {
        paramString.write("&");
      }

      // Urlencode each request parameter
      paramString.write(HttpUtil.urlEncode(key));
      if (value.notNullOrEmpty) {
        paramString
          ..write("=")
          ..write(HttpUtil.urlEncode(value));
      }

      first = false;
    });

    return paramString.toString();
  }

  static String populateMapToBase64JsonString(Map<String, String> map) {
    return base64.encode(jsonEncode(map).codeUnits);
  }

  /// 根据ak/sk、content生成token
  ///
  /// @param accessKey
  /// @param screctKey
  /// @param content
  /// @return
  static String sign(String accessKey, String screctKey, String content) {
    String signature;

    try {
      signature = HmacSHA1Signature().computeSignature(screctKey, content)!;
      signature = signature.trim();
    } catch (e) {
      throw Exception("Compute signature failed! $e");
    }

    return "OSS " + accessKey + ":" + signature;
  }

  static bool isOssOriginHost(String host) {
    if (host.nullOrEmpty) {
      return false;
    }
    for (String suffix in OSSConstants.ossOrignHost) {
      if (host.toLowerCase().endsWith(suffix)) {
        return true;
      }
    }
    return false;
  }

  /// 判断一个域名是否是cname
  static bool isCname(String host) {
    for (String suffix in OSSConstants.defaultCnameExcludeList) {
      if (host.toLowerCase().endsWith(suffix)) {
        return false;
      }
    }
    return true;
  }

  /// 判断一个域名是否在自定义Cname排除列表之中
  static bool isInCustomCnameExcludeList(
      String endpoint, List<String> customCnameExludeList) {
    for (String host in customCnameExludeList) {
      if (endpoint.endsWith(host.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  static void assertTrue(bool condition, String message) {
    if (!condition) {
      throw ArgumentError(message);
    }
  }

  /// 校验bucketName的合法性
  ///
  /// @param bucketName
  /// @return
  static bool validateBucketName(String? bucketName) {
    if (bucketName == null) {
      return false;
    }
    final String BUCKETNAMEREGX = "^[a-z0-9][a-z0-9\\-]{1,61}[a-z0-9]\$";
    return RegExp(BUCKETNAMEREGX).hasMatch(bucketName);
  }

  static void ensureBucketNameValid(String? bucketName) {
    if (!validateBucketName(bucketName)) {
      throw ArgumentError("The bucket name is invalid. \n"
              "A bucket name must: \n" +
          "1) be comprised of lower-case characters, numbers or dash(-); \n" +
          "2) start with lower case or numbers; \n" +
          "3) be between 3-63 characters int. ");
    }
  }

  /// 校验objectKey的合法性
  ///
  /// @param objectKey
  /// @return
  static bool validateObjectKey(String? objectKey) {
    if (objectKey == null) {
      return false;
    }
    if (objectKey.isEmpty || objectKey.length > 1023) {
      return false;
    }
    // List<int> keyBytes;
    // try {
    //     keyBytes = utf8.encode(objectKey);
    // } catch ( e) {
    //     return false;
    // }
    String beginKeyChar = objectKey.substring(0, 1);
    if (beginKeyChar == '/' || beginKeyChar == '\\') {
      return false;
    }
    for (int i = 0; i < objectKey.length; i++) {
      int keyChar = objectKey.codeUnitAt(i);
      if (keyChar != 0x09 && keyChar < 0x20) {
        return false;
      }
    }
    return true;
  }

  static void ensureObjectKeyValid(String? objectKey) {
    if (!validateObjectKey(objectKey)) {
      throw ArgumentError(
          "The object key is invalid. \n" "An object name should be: \n" +
              "1) between 1 - 1023 bytes int when encoded as UTF-8 \n" +
              "2) cannot contain LF or CR or unsupported chars in XML1.0, \n" +
              "3) cannot begin with \"/\" or \"\\\".");
    }
  }

  static bool doesRequestNeedObjectKey(OSSRequest request) {
    if (request is ListObjectsRequest ||
        request is ListBucketsRequest ||
        request is CreateBucketRequest ||
        request is DeleteBucketRequest ||
        request is GetBucketInfoRequest ||
        request is GetBucketACLRequest ||
        request is DeleteMultipleObjectRequest ||
        request is ListMultipartUploadsRequest ||
        request is GetBucketRefererRequest ||
        request is PutBucketRefererRequest ||
        request is PutBucketLoggingRequest ||
        request is GetBucketLoggingRequest ||
        request is PutBucketLoggingRequest ||
        request is GetBucketLoggingRequest ||
        request is DeleteBucketLoggingRequest ||
        request is PutBucketLifecycleRequest ||
        request is GetBucketLifecycleRequest ||
        request is DeleteBucketLifecycleRequest) {
      return false;
    } else {
      return true;
    }
  }

  static bool doesBucketNameValid(OSSRequest request) {
    if (request is ListBucketsRequest) {
      return false;
    } else {
      return true;
    }
  }

  static void ensureRequestValid(OSSRequest request, RequestMessage message) {
    if (doesBucketNameValid(request)) {
      ensureBucketNameValid(message.bucketName);
    }
    if (doesRequestNeedObjectKey(request)) {
      ensureObjectKeyValid(message.objectKey);
    }

    if (request is CopyObjectRequest) {
      ensureObjectKeyValid(request.destinationKey);
    }
  }

  static String determineContentType(
      String? initValue, String? srcPath, String? toObjectKey) {
    if (initValue != null) {
      return initValue;
    }

    if (srcPath != null) {
      // String extension = srcPath.substring(srcPath.lastIndexOf('.') + 1);
      String? contentType = mime.lookupMimeType(srcPath);
      if (contentType != null) {
        return contentType;
      }
    }

    if (toObjectKey != null) {
      // String extension = toObjectKey.substring(toObjectKey.lastIndexOf('.') + 1);
      String? contentType = mime.lookupMimeType(toObjectKey);
      if (contentType != null) {
        return contentType;
      }
    }

    return "application/octet-stream";
  }

  static void signRequest(RequestMessage message) async {
    OSSLog.logDebug("signRequest start");
    if (!message.isAuthorizationRequired) {
      return;
    } else {
      if (message.credentialProvider == null) {
        throw ArgumentError("当前CredentialProvider为空！！！"
                "\n1. 请检查您是否在初始化OSSService时设置CredentialProvider;" +
            "\n2. 如果您bucket为公共权限，请确认获取到Bucket后已经调用Bucket中接口声明ACL;");
      }
    }

    OSSCredentialProvider credentialProvider = message.credentialProvider!;
    OSSFederationToken? federationToken;
    if (credentialProvider is OSSFederationCredentialProvider) {
      federationToken = await credentialProvider.getValidFederationToken();
      if (federationToken == null) {
        OSSLog.logError("Can't get a federation token");
        throw OSSIOException("Can't get a federation token");
      }
      message.headers[OSSHeaders.ossSecurityToken] =
          federationToken.securityToken;
    } else if (credentialProvider is OSSStsTokenCredentialProvider) {
      federationToken = await credentialProvider.getFederationToken();
      message.headers[OSSHeaders.ossSecurityToken] =
          federationToken.securityToken;
    }

    String contentToSign = OSSUtils.buildCanonicalString(message);
    String signature = "---initValue---";
    OSSLog.logDebug("get contentToSign");
    if (credentialProvider is OSSFederationCredentialProvider ||
        credentialProvider is OSSStsTokenCredentialProvider) {
      signature = OSSUtils.sign(
          federationToken!.tempAK, federationToken.tempSK, contentToSign);
    } else if (credentialProvider is OSSPlainTextAKSKCredentialProvider) {
      signature = OSSUtils.sign(credentialProvider.accessKeyId,
          credentialProvider.accessKeySecret, contentToSign);
    } else if (credentialProvider is OSSCustomSignerCredentialProvider) {
      signature = credentialProvider.signContent(contentToSign);
    }

//        OSSLog.logDebug("signed content: " + contentToSign.replaceAll("\n", "@") + "   ---------   signature: " + signature);
    OSSLog.logDebug(
        "signed content: " +
            contentToSign +
            "   \n ---------   signature: " +
            signature,
        write2local: false);

    OSSLog.logDebug("get signature");
    message.headers[HttpHeaders.authorization] = signature;
  }

  static String buildBaseLogInfo() {
    StringBuffer sb = StringBuffer();
    sb.write("=====[device info]=====\n");
    // sb.write("[INFO]: androidVersion：" + Build.VERSION.RELEASE + "\n");
    // sb.write("[INFO]: mobileModel：" + Build.MODEL + "\n");
    return sb.toString();
  }

  /// Checks if OSS and SDK's checksum is same. If not, throws InconsistentException.
  static void checkChecksum(
      String? clientChecksum, String? serverChecksum, String? requestId) {
    if (clientChecksum != null &&
        serverChecksum != null &&
        clientChecksum != serverChecksum) {
      throw InconsistentException(clientChecksum, serverChecksum, requestId);
    }
  }

  /*
     * check is standard ip

     static bool isValidateIP(String addr) {
        if (addr.length() < 7 || addr.length() > 15 || "".equals(addr)) {
            return false;
        }

        //判断IP格式和范围
        String rexp = "([1-9]|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])(\\.(\\d|[1-9]\\d|1\\d{2}|2[0-4]\\d|25[0-5])){3}";

        Pattern pat = Pattern.compile(rexp);

        Matcher mat = pat.matcher(addr);

        bool ipAddress = mat.find();

        return ipAddress;
    }
    */

  /// *
  /// @param host
  /// @return
  static bool isValidateIP(String? host) {
    if (host == null) {
      throw Exception("host is null");
    }

    // if (Build.VERSION.SDKINT >= Build.VERSIONCODES.Q) {
    //     return InetAddresses.isNumericAddress(host);
    // } else {
    //     try {
    //         Class<?> aClass = Class.forName("java.net.InetAddress");
    //         Method isNumeric = aClass.getMethod("isNumeric", String.class);
    //         bool isIp = (bool) isNumeric.invoke(null, host);
    //         return isIp;
    //     } catch ( e) {
    //         return false;
    //     }
    // }
    return true;
  }

  static String buildTriggerCallbackBody(
      Map<String, String>? callbackParams, Map<String, String>? callbackVars) {
    StringBuffer builder = StringBuffer();
    builder.write("x-oss-process=trigger/callback,callback");

    if (callbackParams != null && callbackParams.isNotEmpty) {
      String paramsJsonString = populateMapToBase64JsonString(callbackParams);
      builder.write(paramsJsonString);
    }
    builder.write("," "callback-var");

    if (callbackVars != null && callbackVars.isNotEmpty) {
      String varsJsonString = populateMapToBase64JsonString(callbackVars);
      builder.write(varsJsonString);
    }

    return builder.toString();
  }

  static String buildImagePersistentBody(
      String toBucketName, String toObjectKey, String action) {
    StringBuffer builder = StringBuffer();
    builder.write("x-oss-process=");
    if (action.startsWith("image/")) {
      builder.write(action);
    } else {
      builder.write("image/");
      builder.write(action);
    }
    builder.write("|sys/");
    if (toBucketName.notNullOrEmpty && toObjectKey.notNullOrEmpty) {
      String bucketName_base64 = base64.encode(utf8.encode(toBucketName));
      String objectkey_base64 = base64.encode(utf8.encode(toObjectKey));
      builder.write("saveas,o_");
      builder.write(objectkey_base64);
      builder.write(",b_");
      builder.write(bucketName_base64);
    }
    String body = builder.toString();
    OSSLog.logDebug("ImagePersistent body : " + body);
    return body;
  }
}

enum MetadataDirective {
  /* Copy metadata from source object */
  COPY,

  /* Replace metadata with newly metadata */
  REPLACE,
}
