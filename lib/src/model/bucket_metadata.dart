import 'package:aliyun_oss_dart_sdk/src/internal/oss_headers.dart';

/// OSS Bucket's metadata.

class BucketMetadata {
  /// Gets bucket region.
  String? getBucketRegion() {
    return httpMetadata[OSSHeaders.OSS_BUCKET_REGION];
  }

  /// Sets bucket region. SDK uses.
  void setBucketRegion(String bucketRegion) {
    httpMetadata[OSSHeaders.OSS_BUCKET_REGION]= bucketRegion;
  }

  /// Add http metadata.
  void addHttpMetadata(String key, String value) {
    httpMetadata[key] = value;
  }

  // http headers.
  Map<String, String> httpMetadata = <String, String>{};
}
