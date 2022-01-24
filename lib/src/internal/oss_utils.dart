import 'dart:convert';

import 'package:aliyun_oss_dart_sdk/src/client_configuration.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/response_message.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/binary_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/coding_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/date_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/resource_manager.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';
import 'package:aliyun_oss_dart_sdk/src/inconsistent_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/oss_constants.dart';
import 'package:aliyun_oss_dart_sdk/src/model/callback.dart';
import 'package:aliyun_oss_dart_sdk/src/model/object_metadata.dart';
import 'package:aliyun_oss_dart_sdk/src/model/response_header_overrides.dart';

import 'oss_headers.dart';

class OSSUtils {
  static final ResourceManager OSS_RESOURCE_MANAGER =
      ResourceManager.getInstance(OSSConstants.RESOURCE_NAME_OSS);
  static final ResourceManager COMMON_RESOURCE_MANAGER =
      ResourceManager.getInstance(OSSConstants.RESOURCE_NAME_COMMON);

  static final String BUCKET_NAMING_CREATION_REGEX =
      "^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]\$";
  static final String BUCKET_NAMING_REGEX =
      "^[a-z0-9][a-z0-9-_]{1,61}[a-z0-9]\$";
  static final String ENDPOINT_REGEX = "^[a-zA-Z0-9._-]+\$";

  /// Validate endpoint.
  static bool validateEndpoint(String? endpoint) {
    if (endpoint == null) {
      return false;
    }
    return RegExp(ENDPOINT_REGEX).hasMatch(endpoint);
  }

  static void ensureEndpointValid(String endpoint) {
    if (!validateEndpoint(endpoint)) {
      throw ArgumentError(
          OSS_RESOURCE_MANAGER.getFormattedString("EndpointInvalid", endpoint));
    }
  }

  /// Validate bucket name.
  static bool validateBucketName(String? bucketName) {
    if (bucketName == null) {
      return false;
    }
    return RegExp(BUCKET_NAMING_REGEX).hasMatch(bucketName);
  }

  static void ensureBucketNameValid(String bucketName) {
    if (!validateBucketName(bucketName)) {
      throw ArgumentError(OSS_RESOURCE_MANAGER.getFormattedString(
          "BucketNameInvalid", bucketName));
    }
  }

  /// Validate bucket creation name.
  static bool validateBucketNameCreation(String? bucketName) {
    if (bucketName == null) {
      return false;
    }

    return RegExp(BUCKET_NAMING_CREATION_REGEX).hasMatch(bucketName);
  }

  static void ensureBucketNameCreationValid(String bucketName) {
    if (!validateBucketNameCreation(bucketName)) {
      throw ArgumentError(OSS_RESOURCE_MANAGER.getFormattedString(
          "BucketNameInvalid", bucketName));
    }
  }

  /// Validate object name.
  static bool validateObjectKey(String? key) {
    if (key == null || key.isEmpty) {
      return false;
    }

    List<int> bytes = [];
    try {
      bytes = utf8.encode(key);
    } catch (e) {
      return false;
    }

    // Validate exculde xml unsupported chars
    if (key.substring(0, 1) == '\\') {
      return false;
    }

    return (bytes.isNotEmpty &&
        bytes.length < OSSConstants.OBJECT_NAME_MAX_LENGTH);
  }

  static void ensureObjectKeyValid(String key) {
    if (!validateObjectKey(key)) {
      throw ArgumentError(
          OSS_RESOURCE_MANAGER.getFormattedString("ObjectKeyInvalid", key));
    }
  }

  static void ensureLiveChannelNameValid(String liveChannelName) {
    if (!validateObjectKey(liveChannelName)) {
      throw ArgumentError(OSS_RESOURCE_MANAGER.getFormattedString(
          "LiveChannelNameInvalid", liveChannelName));
    }
  }

  /// Make a third-level domain by appending bucket name to front of original
  /// endpoint if no binding to CNAME, otherwise use original endpoint as
  /// second-level domain directly.
  static Uri determineFinalEndpoint(
      Uri endpoint, String bucket, ClientConfiguration clientConfig) {
    try {
      StringBuffer conbinedEndpoint = StringBuffer();
      conbinedEndpoint
        ..write("${endpoint.scheme}://")
        ..write(buildCanonicalHost(endpoint, bucket, clientConfig))
        ..write(endpoint.port != -1 ? ":${endpoint.port}" : "")
        ..write(endpoint.path);
      return Uri.parse(conbinedEndpoint.toString());
    } catch (ex) {
      throw ArgumentError(ex);
    }
  }

  static String buildCanonicalHost(
      Uri endpoint, String? bucket, ClientConfiguration clientConfig) {
    String host = endpoint.host;

    bool isCname = false;
    if (clientConfig.supportCname) {
      isCname = cnameExcludeFilter(host, clientConfig.getCnameExcludeList());
    }

    StringBuffer cannonicalHost = StringBuffer();
    if (bucket != null && !isCname && !clientConfig.sldEnabled) {
      cannonicalHost
        ..write(bucket)
        ..write(".")
        ..write(host);
    } else {
      cannonicalHost.write(host);
    }

    return cannonicalHost.toString();
  }

  static bool cnameExcludeFilter(
      String? hostToFilter, List<String> excludeList) {
    if (hostToFilter?.trim().isNotEmpty ?? false) {
      String canonicalHost = hostToFilter!.toLowerCase();
      for (String excl in excludeList) {
        if (canonicalHost.endsWith(excl)) {
          return false;
        }
      }
      return true;
    }
    throw ArgumentError("Host name can not be null.");
  }

  static String? determineResourcePath(
      String? bucket, String? key, bool sldEnabled) {
    return sldEnabled
        ? makeResourcePathWithBucket(bucket, key)
        : makeResourcePath(key);
  }

  /// Make a resource path from the object key, used when the bucket name
  /// pearing in the endpoint.
  static String? makeResourcePath(String? key) {
    return key != null ? OSSUtils.urlEncodeKey(key) : null;
  }

  /// Make a resource path from the bucket name and the object key.
  static String? makeResourcePathWithBucket(String? bucket, String? key) {
    if (bucket != null) {
      return bucket + "/" + (key != null ? OSSUtils.urlEncodeKey(key) : "");
    } else {
      return null;
    }
  }

  /// Encode object Uri.
  static String urlEncodeKey(String key) {
    if (key.startsWith("/")) {
      return HttpUtil.urlEncode(key, OSSConstants.DEFAULT_CHARSET_NAME);
    }

    StringBuffer resultUri = StringBuffer();

    List<String> keys = key.split("/");
    resultUri
        .write(HttpUtil.urlEncode(keys[0], OSSConstants.DEFAULT_CHARSET_NAME));
    for (int i = 1; i < keys.length; i++) {
      resultUri
        ..write("/")
        ..write(HttpUtil.urlEncode(keys[i], OSSConstants.DEFAULT_CHARSET_NAME));
    }

    if (key.endsWith("/")) {
      // String#split ignores trailing empty strings,
      // e.g., "a/b/" will be split as a 2-entries array,
      // so we have to append all the trailing slash to the Uri.
      for (int i = key.length - 1; i >= 0; i--) {
        if (key.substring(i, i + 1) == '/') {
          resultUri.write("/");
        } else {
          break;
        }
      }
    }

    return resultUri.toString();
  }

  /// Populate metadata to headers.
  static void populateRequestMetadata(
      Map<String, String> headers, ObjectMetadata metadata) {
    Map<String, Object> rawMetadata = metadata.getRawMetadata();
    rawMetadata.forEach((entryKey, entryValue) {
      String key = entryKey;
      String value = entryValue.toString();
      if (key != null) key = key.trim();
      if (value != null) value = value.trim();
      headers[key] = value;
    });

    Map<String, String> userMetadata = metadata.getUserMetadata();
    userMetadata.forEach((entryKey, entryValue) {
      String key = entryKey;
      String value = entryValue;
      if (key != null) key = key.trim();
      if (value != null) value = value.trim();
      headers[OSSHeaders.OSS_USER_METADATA_PREFIX + key] = value;
    });
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
    if (values?.isNotEmpty ?? false) {
      headers[header] = values!.join();
    }
  }

  static void removeHeader(Map<String, String> headers, String? header) {
    if (header != null && headers.containsKey(header)) {
      headers.remove(header);
    }
  }

  static String join(List<String> strings) {
    StringBuffer sb = StringBuffer();
    bool first = true;

    for (String s in strings) {
      if (!first) {
        sb.write(", ");
      }
      sb.write(s);

      first = false;
    }

    return sb.toString();
  }

  static String? trimQuotes(String? s) {
    if (s == null) {
      return null;
    }

    s = s.trim();
    if (s.startsWith('"')) {
      s = s.substring(1);
    }
    if (s.endsWith('"')) {
      s = s.substring(0, s.length - 1);
    }

    return s;
  }

  static void populateResponseHeaderParameters(
      Map<String, String> params, ResponseHeaderoverrides responseHeaders) {
    responseHeaders.cacheControl.applyNull((p0) {
      params[ResponseHeaderoverrides.RESPONSE_HEADER_CACHE_CONTROL] = p0;
    });
    responseHeaders.contentDisposition.applyNull((p0) {
      params[ResponseHeaderoverrides.RESPONSE_HEADER_CONTENT_DISPOSITION] = p0;
    });

    responseHeaders.contentEncoding.applyNull((p0) {
      params[ResponseHeaderoverrides.RESPONSE_HEADER_CONTENT_ENCODING] = p0;
    });

    responseHeaders.contentLangauge.applyNull((p0) {
      params[ResponseHeaderoverrides.RESPONSE_HEADER_CONTENT_LANGUAGE] = p0;
    });

    responseHeaders.contentType.applyNull((p0) {
      params[ResponseHeaderoverrides.RESPONSE_HEADER_CONTENT_TYPE] = p0;
    });

    responseHeaders.expires.applyNull((p0) {
      params[ResponseHeaderoverrides.RESPONSE_HEADER_EXPIRES] = p0;
    });
  }

  static void safeCloseResponse(ResponseMessage response) {
    try {
      response.close();
    } catch (ignored) {}
  }

  static void mandatoryCloseResponse(ResponseMessage response) {
    try {
      response.abort();
    } catch (e) {}
  }

  static int determineInputStreamLength(InputStream instream, int hintLength,
      [bool useChunkEncoding = false]) {
    if (useChunkEncoding) {
      return -1;
    }

    if (hintLength <= 0 || !instream.markSupported()) {
      return -1;
    }

    return hintLength;
  }

  static String joinETags(List<String> eTags) {
    StringBuffer sb = StringBuffer();
    bool first = true;

    for (String eTag in eTags) {
      if (!first) {
        sb.write(", ");
      }
      sb.write(eTag);

      first = false;
    }

    return sb.toString();
  }

  /// Encode the callback with JSON.
  static String jsonizeCallback(Callback callback) {
    StringBuffer jsonBody = StringBuffer();

    jsonBody.write("{");
    // url, required
    jsonBody.write('"callbackUrl":"${callback.callbackUrl}"');

    // host, optional
    if (callback.callbackHost?.isNotEmpty ?? false) {
      jsonBody.write(',"callbackHost":"${callback.callbackHost}"');
    }

    // body, require
    jsonBody.write(',"callbackBody":"{callback.callbackBody}"');

    // bodyType, optional
    if (callback.calbackBodyType == CallbackBodyType.JSON) {
      jsonBody.write(',"callbackBodyType":"application/json"');
    } else if (callback.calbackBodyType == CallbackBodyType.URL) {
      jsonBody.write(',"callbackBodyType":"application/x-www-form-urlencoded"');
    }
    jsonBody.write("}");

    return jsonBody.toString();
  }

  /// Encode CallbackVar with Json.
  static String jsonizeCallbackVar(Callback callback) {
    StringBuffer jsonBody = StringBuffer();

    jsonBody.write("{");
    callback.getCallbackVar().forEach((key, value) {
      if (jsonBody.toString() != "{") {
        jsonBody.write(",");
      }
      jsonBody.write('"$key":"$value" ');
    });
    jsonBody.write("}");

    return jsonBody.toString();
  }

  /// Ensure the callback is valid by checking its url and body are not null or
  /// empty.
  static void ensureCallbackValid(Callback? callback) {
    if (callback != null) {
      CodingUtils.assertStringNotNullOrEmpty(
          callback.callbackUrl, "Callback.callbackUrl");
      CodingUtils.assertParameterNotNull(
          callback.callbackBody, "Callback.callbackBody");
    }
  }

  /// Put the callback parameter into header.
  static void populateRequestCallback(
      Map<String, String> headers, Callback? callback) {
    if (callback != null) {
      String jsonCb = jsonizeCallback(callback);
      String base64Cb = BinaryUtil.toBase64String(utf8.encode(jsonCb));

      headers[OSSHeaders.OSS_HEADER_CALLBACK] = base64Cb;

      if (callback.hasCallbackVar()) {
        String jsonCbVar = jsonizeCallbackVar(callback);
        String base64CbVar = BinaryUtil.toBase64String(utf8.encode(jsonCbVar));
        base64CbVar = base64CbVar.replaceAll("\n", "").replaceAll("\r", "");
        headers[OSSHeaders.OSS_HEADER_CALLBACK_VAR] = base64CbVar;
      }
    }
  }

  /// Checks if OSS and SDK's checksum is same. If not, throws
  /// InconsistentException.
  static void checkChecksum(
      int? clientChecksum, int? serverChecksum, String requestId) {
    if (clientChecksum != null &&
        serverChecksum != null &&
        clientChecksum != serverChecksum) {
      throw InconsistentException(clientChecksum, serverChecksum, requestId);
    }
  }

  static Uri toEndpointUri(String? endpoint, String defaultProtocol) {
    if (endpoint != null && !endpoint.contains("://")) {
      endpoint = defaultProtocol + "://" + endpoint;
    }

    try {
      return Uri.parse(endpoint!);
    } catch (e) {
      throw ArgumentError(e);
    }
  }
}

extension on String {
  apply(Function(String) fun) {
    fun(this);
  }
}

extension on String? {
  applyNull(Function(String) fun) {
    if (this != null) {
      fun(this!);
    }
  }
}
