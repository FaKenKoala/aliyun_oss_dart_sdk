import 'package:aliyun_oss_dart_sdk/src/common/utils/http_headers.dart';

abstract class OSSHeaders extends HttpHeaders {
  static final String ossPrefix = "x-oss-";
  static final String ossUserMetadataPrefix = "x-oss-meta-";

  static final String ossCannedAcl = "x-oss-acl";
  static final String storageClass = "x-oss-storage-class";
  static final String ossVersionId = "x-oss-version-id";

  static final String ossServerSideEncryption = "x-oss-server-side-encryption";
  static final String ossServerSideEncryptionKeyId =
      "x-oss-server-side-encryption-key-id";
  static final String ossServerSideDataEncryption =
      "x-oss-server-side-data-encryption";

  static final String getObjectIfModifiedSince = "If-Modified-Since";
  static final String getObjectIfUnmodifiedSince = "If-Unmodified-Since";
  static final String getObjectIfMatch = "If-Match";
  static final String getObjectIfNoneMatch = "If-None-Match";

  static final String headObjectIfModifiedSince = "If-Modified-Since";
  static final String headObjectIfUnmodifiedSince = "If-Unmodified-Since";
  static final String headObjectIfMatch = "If-Match";
  static final String headObjectIfNoneMatch = "If-None-Match";

  static final String copyObjectSource = "x-oss-copy-source";
  static final String copySourceRange = "x-oss-copy-source-range";
  static final String copyObjectSourceIfMatch = "x-oss-copy-source-if-match";
  static final String copyObjectSourceIfNoneMatch =
      "x-oss-copy-source-if-none-match";
  static final String copyObjectSourceIfUnmodifiedSince =
      "x-oss-copy-source-if-unmodified-since";
  static final String copyObjectSourceIfModifiedSince =
      "x-oss-copy-source-if-modified-since";
  static final String copyObjectMetadataDirective = "x-oss-metadata-directive";
  static final String copyObjectTaggingDirective = "x-oss-tagging-directive";

  static final String ossHeaderRequestId = "x-oss-request-id";
  static final String ossHeaderVersionId = "x-oss-version-id";

  static final String origin = "origin";
  static final String accessControlRequestMethod =
      "access-control-request-method";
  static final String accessControlRequestHeader =
      "access-control-request-headers";

  static final String accessControlAllowOrigin = "access-control-allow-origin";
  static final String accessControlAllowMethods =
      "access-control-allow-methods";
  static final String accessControlAllowHeaders =
      "access-control-allow-headers";
  static final String accessControlExposeHeaders =
      "access-control-expose-headers";
  static final String accessControlMaxAge = "access-control-max-age";

  static final String ossSecurityToken = "x-oss-security-token";

  static final String ossNextAppendPosition = "x-oss-next-append-position";
  static final String ossHashCrc64Ecma = "x-oss-hash-crc64ecma";
  static final String ossObjectType = "x-oss-object-type";

  static final String ossObjectAcl = "x-oss-object-acl";

  static final String ossHeaderCallback = "x-oss-callback";
  static final String ossHeaderCallbackVar = "x-oss-callback-var";
  static final String ossHeaderSymlinkTarget = "x-oss-symlink-target";

  static final String ossStorageClass = "x-oss-storage-class";
  static final String ossRestore = "x-oss-restore";
  static final String ossOngoingRestore = "ongoing-request=\"true\"";

  static final String ossBucketRegion = "x-oss-bucket-region";

  static final String ossSelectPrefix = "x-oss-select";
  static final String ossSelectCsvRows = ossSelectPrefix + "-csv-rows";
  static final String ossSelectOutputRaw = ossSelectPrefix + "-output-raw";
  static final String ossSelectCsvSplits = ossSelectPrefix + "-csv-splits";
  static final String ossSelectInputLineRange = ossSelectPrefix + "-line-range";
  static final String ossSelectInputSplitRange =
      ossSelectPrefix + "-split-range";

  static final String ossTagging = "x-oss-tagging";

  static final String ossRequestPayer = "x-oss-request-payer";

  static final String ossHeaderTrafficLimit = "x-oss-traffic-limit";

  static final String ossHeaderTaskId = "x-oss-task-id";

  static final String ossHeaderWormId = "x-oss-worm-id";

  static final String ossHeaderCertId = "x-oss-yundun-certificate-id";

  static final String ossHnsStatus = "x-oss-hns-status";

  static final String ossDeleteRecursive = "x-oss-delete-recursive";
  static final String ossDeleteToken = "x-oss-delete-token";

  static final String ossRenameSource = "x-oss-rename-source";

  static final String ossResourceGroupId = "x-oss-resource-group-id";
}
