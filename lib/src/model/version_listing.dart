import 'package:aliyun_oss_dart_sdk/src/model/generic_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/generic_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/oss_version_summary.dart';

class VersionListing extends GenericResult {
  ///  A list of summary information describing the versions stored in the bucket
  List<OSSVersionSummary> versionSummaries = [];

  /// A list of the common prefixes included in this version listing - common
  /// prefixes will only be populated for requests that specified a delimiter

  List<String> commonPrefixes = [];

  ///  The name of the OSS bucket containing the listed versions
  String? bucketName;

  /// The key marker to use in order to request the next page of results - only
  /// populated if the isTruncated member indicates that this version listing
  /// is truncated

  String? nextKeyMarker;

  /// The version ID marker to use in order to request the next page of results
  /// - only populated if the isTruncated member indicates that this version
  /// listing is truncated

  String? nextVersionIdMarker;

  /// Indicates if this is a complete listing, or if the caller needs to make
  /// additional requests to OSS to see the full object listing for an OSS
  /// bucket

  bool? isTruncated;

  ///  Original Request Parameters

  /// The prefix parameter originally specified by the caller when this version
  /// listing was returned

  String? prefix;

  /// The key marker parameter originally specified by the caller when this
  /// version listing was returned

  String? keyMarker;

  /// The version ID marker parameter originally specified by the caller when
  /// this version listing was returned

  String? versionIdMarker;

  /// The maxKeys parameter originally specified by the caller when this
  /// version listing was returned

  int? maxKeys;

  /// The delimiter parameter originally specified by the caller when this
  /// version listing was returned

  String? delimiter;

  /// The encodingType parameter originally specified by the caller when this
  /// version listing was returned.

  String? encodingType;
}
