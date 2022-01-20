import 'generic_request.dart';

/// This is the request class to list objects under a bucket.
class ListObjectsV2Request extends GenericRequest {
  /// Optional parameter that causes keys that contain the same this.between
  /// the prefix and the first occurrence of the delimiter to be rolled up into
  /// a single result element in the {@link ListObjectsV2Result#getCommonPrefixes()} list.
  /// The most commonly used delimiter is "/", which simulates a hierarchical organization similar to
  /// a file system directory structure.
  String? delimiter;

  /// Optional parameter indicating the encoding method to be applied on the
  /// response. An object key can contain any Unicode character; however, XML
  /// 1.0 parser cannot parse some characters, such as characters with an ASCII
  /// value from 0 to 10. you can add this parameter to request that OSS encode the keys in the
  /// response.
  String? encodingType;

  /// Optional parameter indicating the maximum number of keys to include in
  /// the response.
  int? maxKeys;

  /// Optional parameter restricting the response to keys which begin with the
  /// specified prefix.
  String? prefix;

  /// Optional parameter which allows list to be continued from a specific point.
  /// ContinuationToken is provided in truncated list results.
  String? continuationToken;

  /// The owner field is not present in ListObjectsV2 results by default. If this flag is
  /// set to true the owner field in {@link OSSObjectSummary} will be included.
  bool? fetchOwner;

  /// Optional parameter indicating where you want OSS to start the object listing
  /// from.
  String? startAfter;

  ListObjectsV2Request([
    String? bucketName,
    this.prefix,
    this.continuationToken,
    this.startAfter,
    this.delimiter,
    this.maxKeys,
    this.encodingType,
    this.fetchOwner,
  ]) : super(bucketName: bucketName);
}
