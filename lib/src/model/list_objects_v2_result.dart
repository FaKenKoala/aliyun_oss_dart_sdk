import 'generic_result.dart';
import 'oss_object_summary.dart';

/// This is the result of the listing objects request.
class ListObjectsV2Result extends GenericResult {
  /// A list of summary information describing the objects stored in the bucket
  final List<OSSObjectSummary> _objectSummaries = [];

  /// A list of the common prefixes included in this object listing - common
  final List<String> _commonPrefixes = [];

  /// The name of the bucket
  String? bucketName;

  /// KeyCount is the number of keys returned with this response
  int? keyCount;

  /// Optional parameter which allows list to be continued from a specific point.
  /// ContinuationToken is provided in truncated list results.
  String? continuationToken;

  /// NextContinuationToken is sent when isTruncated is true meaning there are
  /// more keys in the bucket that can be listed.
  String? nextContinuationToken;

  /// Optional parameter indicating where you want OSS to start the object listing
  /// from.  This can be any key in the bucket.
  String? startAfter;

  /// Indicates if this is a complete listing, or if the caller needs to make
  /// additional requests to OSS to see the full object listing.
  bool? isTruncated;

  /// The prefix parameter originally specified by the caller when this object
  /// listing was returned
  String? prefix;

  /// The maxKeys parameter originally specified by the caller when this object
  /// listing was returned
  int? maxKeys;

  /// The delimiter parameter originally specified by the caller when this
  /// object listing was returned
  String? delimiter;

  /// The encodingType parameter originally specified by the caller when this
  /// object listing was returned.
  String? encodingType;

  /// Gets the list of object summaries describing the objects stored in the bucket.
  List<OSSObjectSummary> getObjectSummaries() {
    return _objectSummaries;
  }

  /// Add the object summary to the list of the object summaries
  void addObjectSummary(OSSObjectSummary objectSummary) {
    _objectSummaries.add(objectSummary);
  }

  /// Gets the common prefixes included in this object listing. Common
  /// prefixes are only present if a delimiter was specified in the original
  /// request.
  ///
  /// For example, consider a bucket that contains the following objects:
  /// "fun/test.jpg", "fun/movie/001.avi", "fun/movie/007.avi".
  /// if calling the prefix="fun/" and delimiter="/", the returned
  /// {@link ListObjectsV2Result} object will contain the common prefix of "fun/movie/".
  ///
  /// @return The list of common prefixes included in this object listing,
  ///         which might be an empty list if no common prefixes were found.
  List<String> getCommonPrefixes() {
    return _commonPrefixes;
  }

  /// adds a common prefix element to the common prefixes list
  void addCommonPrefix(String commonPrefix) {
    _commonPrefixes.add(commonPrefix);
  }
}
