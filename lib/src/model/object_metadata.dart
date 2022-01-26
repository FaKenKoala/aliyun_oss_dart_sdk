import 'dart:collection';

import 'package:aliyun_oss_dart_sdk/src/common/oss_constants.dart';
import 'package:aliyun_oss_dart_sdk/src/common/oss_headers.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/date_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/extension_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_headers.dart';

class ObjectMetadata {
  static final String AES_256_SERVER_SIDE_ENCRYPTION = "AES256";
  // User's custom metadata dictionary. All keys  will be prefixed with x-oss-meta-in the HTTP headers.
  // The keys in this dictionary should include the prefix 'x-oss-meta-'.
  final Map<String, String> _userMetadata = LinkedHashMap<String, String>(
      equals: (p0, p1) => p0.equalsIgnoreCase(p1));
  // Standard metadata
  Map<String, Object> metadata = LinkedHashMap<String, Object>(
    equals: (p0, p1) => p0.equalsIgnoreCase(p1),
  );

  Map<String, String> getUserMetadata() {
    return _userMetadata;
  }

  void setUserMetadata(Map<String, String>? userMetadata) {
    _userMetadata
      ..clear
      ..addAll(userMetadata ?? {});
  }

  void setHeader(String key, Object value) {
    metadata[key] = value;
  }

  void addUserMetadata(String key, String value) {
    _userMetadata[key] = value;
  }

  DateTime? getLastModified() {
    return metadata[HttpHeaders.lastModified] as DateTime?;
  }

  void setLastModified(DateTime lastModified) {
    metadata[HttpHeaders.lastModified] = lastModified;
  }

  DateTime getExpirationTime() {
    return DateUtil.parseRfc822Date(metadata[HttpHeaders.expires] as String);
  }

  void setExpirationTime(DateTime expirationTime) {
    metadata[HttpHeaders.expires] = DateUtil.formatRfc822Date(expirationTime);
  }

  String? getRawExpiresValue() {
    return metadata[HttpHeaders.expires] as String?;
  }

  int getContentLength() {
    return (metadata[HttpHeaders.contentLength] as int?) ?? 0;
  }

  void setContentLength(int contentLength) {
    if (contentLength > OSSConstants.defaultFileSizeLimit) {
      throw ArgumentError("The content length could not be more than 5GB.");
    }

    metadata[HttpHeaders.contentLength] = contentLength;
  }

  /// Gets Content-Type header value in MIME types, which means the object's type.
  String? getContentType() {
    return metadata[HttpHeaders.contentType] as String?;
  }

  /// Sets Content-Type header value in MIME types, which means the object's type.
  ///
  /// @param contentType The object Content-Type value in MIME types.
  void setContentType(String contentType) {
    metadata[HttpHeaders.contentType] = contentType;
  }

  String? getContentMD5() {
    return metadata[HttpHeaders.contentMd5] as String?;
  }

  void setContentMD5(String contentMD5) {
    metadata[HttpHeaders.contentMd5] = contentMD5;
  }

  String? getSHA1() {
    return metadata[OSSHeaders.ossHashSha1] as String?;
  }

  void setSHA1(String value) {
    metadata[OSSHeaders.ossHashSha1] = value;
  }

  /// Gets Content-Encoding header value which means the object content's encoding method.
  String? getContentEncoding() {
    return metadata[HttpHeaders.contentEncoding] as String?;
  }

  /// Gets Content-Encoding header value which means the object content's encoding method.
  void setContentEncoding(String encoding) {
    metadata[HttpHeaders.contentEncoding] = encoding;
  }

  /// Gets Cache-Control header value, which specifies the cache behavior of accessing the object.
  String? getCacheControl() {
    return metadata[HttpHeaders.cacheControl] as String?;
  }

  /// Sets Cache-Control header value, which specifies the cache behavior of accessing the object.
  void setCacheControl(String cacheControl) {
    metadata[HttpHeaders.cacheControl] = cacheControl;
  }

  /// Gets Content-Disposition header value, which specifies how MIME agent is going to handle
  /// attachments.
  String? getContentDisposition() {
    return metadata[HttpHeaders.contentDisposition] as String?;
  }

  /// Gets Content-Disposition header value, which specifies how MIME agent is going to handle
  /// attachments.
  void setContentDisposition(String disposition) {
    metadata[HttpHeaders.contentDisposition] = disposition;
  }

  /// Gets the ETag value which is the 128bit MD5 digest in HEX encoding.
  String? getETag() {
    return metadata[HttpHeaders.etag] as String?;
  }

  /// Gets the server side encryption algorithm.
  String? getServerSideEncryption() {
    return metadata[OSSHeaders.ossServerSideEncryption] as String?;
  }

  /// Sets the server side encryption algorithm.
  void setServerSideEncryption(String serverSideEncryption) {
    metadata[OSSHeaders.ossServerSideEncryption] = serverSideEncryption;
  }

  /// Gets Object type---Normal or Appendable
  String? getObjectType() {
    return metadata[OSSHeaders.ossObjectType] as String?;
  }

  /// Gets the raw metadata dictionary (SDK internal only)
  Map<String, Object> getRawMetadata() {
    return UnmodifiableMapView(metadata);
  }

  @override
  String toString() {
    String s;
    String expirationTimeStr = "";
    try {
      DateTime expirationTime = getExpirationTime();
      expirationTimeStr = expirationTime.toString();
    } catch (e) {}
    s = HttpHeaders.lastModified +
        ":" +
        "${getLastModified()}" +
        "\n" +
        HttpHeaders.expires +
        ":" +
        expirationTimeStr +
        "\n" +
        "rawExpires" +
        ":" +
        "${getRawExpiresValue()}" +
        "\n" +
        HttpHeaders.contentMd5 +
        ":" +
        "${getContentMD5()}" +
        "\n" +
        OSSHeaders.ossObjectType +
        ":" +
        "${getObjectType()}" +
        "\n" +
        OSSHeaders.ossServerSideEncryption +
        ":" +
        "${getServerSideEncryption()}" +
        "\n" +
        HttpHeaders.contentDisposition +
        ":" +
        "${getContentDisposition()}" +
        "\n" +
        HttpHeaders.contentEncoding +
        ":" +
        "${getContentEncoding()}" +
        "\n" +
        HttpHeaders.cacheControl +
        ":" +
        "${getCacheControl()}" +
        "\n" +
        HttpHeaders.etag +
        ":" +
        "${getETag()}" +
        "\n";

    return s;
  }
}
