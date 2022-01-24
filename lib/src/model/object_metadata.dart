// ignore_for_file: non_constant_identifier_names

import 'dart:collection';

import 'package:aliyun_oss_dart_sdk/src/common/utils/date_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_headers.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/oss_headers.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/sign_v2_utils.dart';

import 'canned_access_control_list.dart';
import 'storage_class.dart';

/// OSS Object's metadata. It has the user's custom metadata, as well as some
/// standard http headers sent to OSS, such as Content-Length, ETag, etc.
class ObjectMetadata {
  // The user's custom metadata, whose prefix in http header is x-oss-meta-.
  final Map<String, String> _userMetadata = <String, String>{};

  // Other non-custom metadata.
  Map<String, Object> metadata = <String, Object>{};

  static final String AES_256_SERVER_SIDE_ENCRYPTION = "AES256";

  static final String KMS_SERVER_SIDE_ENCRYPTION = "KMS";

  Map<String, String> getUserMetadata() {
    return _userMetadata;
  }

  void setUserMetadata(Map<String, String>? userMetadata) {
    _userMetadata
      ..clear()
      ..addAll(userMetadata ?? {});
  }

  void setHeader(String key, Object value) {
    metadata[key] = value;
  }

  void removeHeader(String key) {
    metadata.remove(key);
  }

  void addUserMetadata(String key, String value) {
    _userMetadata[key] = value;
  }

  DateTime? getLastModified() {
    return metadata[HttpHeaders.LAST_MODIFIED] as DateTime?;
  }

  void setLastModified(DateTime lastModified) {
    metadata[HttpHeaders.LAST_MODIFIED] = lastModified;
  }

  DateTime? getExpirationTime() {
    String? expires = metadata[HttpHeaders.EXPIRES] as String?;

    if (expires != null) {
      return DateUtil.parseRfc822Date(expires);
    }

    return null;
  }

  String? getRawExpiresValue() {
    return metadata[HttpHeaders.EXPIRES] as String?;
  }

  void setExpirationTime(DateTime expirationTime) {
    metadata[HttpHeaders.EXPIRES] = DateUtil.formatRfc822Date(expirationTime);
  }

  int getContentLength() {
    int? contentLength = metadata[HttpHeaders.CONTENT_LENGTH] as int?;
    return contentLength ?? 0;
  }

  void setContentLength(int contentLength) {
    metadata[HttpHeaders.CONTENT_LENGTH] = contentLength;
  }

  String? getContentType() {
    return metadata[HttpHeaders.CONTENT_TYPE] as String?;
  }

  void setContentType(String contentType) {
    metadata[HttpHeaders.CONTENT_TYPE] = contentType;
  }

  String? getContentMD5() {
    return metadata[HttpHeaders.CONTENT_MD5] as String?;
  }

  void setContentMD5(String contentMD5) {
    metadata[HttpHeaders.CONTENT_MD5] = contentMD5;
  }

  String? getContentEncoding() {
    return metadata[HttpHeaders.CONTENT_ENCODING] as String?;
  }

  void setContentEncoding(String encoding) {
    metadata[HttpHeaders.CONTENT_ENCODING] = encoding;
  }

  String? getCacheControl() {
    return metadata[HttpHeaders.CACHE_CONTROL] as String?;
  }

  void setCacheControl(String cacheControl) {
    metadata[HttpHeaders.CACHE_CONTROL] = cacheControl;
  }

  String? getContentDisposition() {
    return metadata[HttpHeaders.CONTENT_DISPOSITION] as String?;
  }

  void setContentDisposition(String disposition) {
    metadata[HttpHeaders.CONTENT_DISPOSITION] = disposition;
  }

  String? getETag() {
    return metadata[HttpHeaders.ETAG] as String?;
  }

  String? getServerSideEncryption() {
    return metadata[OSSHeaders.OSS_SERVER_SIDE_ENCRYPTION] as String?;
  }

  void setServerSideEncryption(String serverSideEncryption) {
    metadata[OSSHeaders.OSS_SERVER_SIDE_ENCRYPTION] = serverSideEncryption;
  }

  String? getServerSideEncryptionKeyId() {
    return metadata[OSSHeaders.OSS_SERVER_SIDE_ENCRYPTION_KEY_ID] as String?;
  }

  void setServerSideEncryptionKeyId(String serverSideEncryptionKeyId) {
    metadata[OSSHeaders.OSS_SERVER_SIDE_ENCRYPTION_KEY_ID] =
        serverSideEncryptionKeyId;
  }

  void setServerSideDataEncryption(String serverSideDataEncryption) {
    metadata[OSSHeaders.OSS_SERVER_SIDE_DATA_ENCRYPTION] = serverSideDataEncryption;
  }

  String? getServerSideDataEncryption() {
    return metadata[OSSHeaders.OSS_SERVER_SIDE_DATA_ENCRYPTION] as String?;
  }

  String? getObjectType() {
    return metadata[OSSHeaders.OSS_OBJECT_TYPE] as String?;
  }

  void setObjectAcl(CannedAccessControlList? cannedAcl) {
    metadata[OSSHeaders.OSS_OBJECT_ACL] =
        cannedAcl != null ? cannedAcl.toString() : "";
  }

  Map<String, Object> getRawMetadata() {
    return UnmodifiableMapView(metadata);
  }

  String? getRequestId() {
    return metadata[OSSHeaders.OSS_HEADER_REQUEST_ID] as String?;
  }

  String? getVersionId() {
    return metadata[OSSHeaders.OSS_HEADER_VERSION_ID] as String?;
  }

  int? getServerCRC() {
    String? strSrvCrc = metadata[OSSHeaders.OSS_HASH_CRC64_ECMA] as String?;

    if (strSrvCrc != null) {
      return int.tryParse(strSrvCrc);
    }
    return null;
  }

  StorageClass? getObjectStorageClass() {
    String? storageClassString =
        metadata[OSSHeaders.OSS_STORAGE_CLASS] as String?;
    if (storageClassString != null) {
      return StorageClassX.parse(storageClassString);
    }
    return StorageClass.Standard;
  }

  String? getObjectRawRestore() {
    return metadata[OSSHeaders.OSS_RESTORE] as String?;
  }

  bool isRestoreCompleted() {
    String? restoreString = getObjectRawRestore();
    if (restoreString == null) {
      throw NullThrownError();
    }

    return restoreString != OSSHeaders.OSS_ONGOING_RESTORE;
  }

  void setObjectTagging(Map<String?, String?>? tags) {
    if (tags == null || tags.isEmpty) {
      return;
    }

    StringBuffer builder = StringBuffer();
    tags.forEach((key, value) {
      if (key == null || key.isEmpty || value == null || value.isEmpty) {
        throw ArgumentError();
      }

      if (builder.length > 0) {
        builder.write("&");
      }
      builder.write(SignV2Utils.uriEncoding(key));
      builder.write("=");
      builder.write(SignV2Utils.uriEncoding(value));
    });

    metadata[OSSHeaders.OSS_TAGGING] = builder.toString();
  }
}
