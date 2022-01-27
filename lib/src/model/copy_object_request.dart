import 'object_metadata.dart';
import 'oss_request.dart';

class CopyObjectRequest extends OSSRequest {
  // Source Object's bucket name
  String sourceBucketName;

  // Source Object's key
  String sourceKey;

  // Target Object's bucket name
  String destinationBucketName;

  // Target Object Key
  String destinationKey;

  // Target Object's server side encryption method
  String? serverSideEncryption;

  // Target Object Metadata
  ObjectMetadata? newObjectMetadata;

  // The ETag matching constraints. If the source object's ETag matches the one user provided, copy the file.
  // Otherwise returns 412 (precondition failed).
  final List<String> _matchingETagConstraints = [];

  // The ETag non-matching constraints. If the source object's ETag does not match the one user provided, copy the file.
  // Otherwise returns 412 (precondition failed).
  final List<String> _nonmatchingEtagConstraints = [];

  // The unmodified since constraint. If the parameter value is same or later than the actual file's modified time, copy the file.
  // Otherwise returns 412 (precondition failed).
  DateTime? unmodifiedSinceConstraint;

  // The modified since constraint. If the parameter value is earlier than the actual file's modified time, copy the file.
  // Otherwise returns 412 (precondition failed).
  DateTime? modifiedSinceConstraint;

  CopyObjectRequest(this.sourceBucketName, this.sourceKey,
      this.destinationBucketName, this.destinationKey);

  List<String> getMatchingETagConstraints() {
    return _matchingETagConstraints;
  }

  void setMatchingETagConstraints(List<String>? matchingETagConstraints) {
    _matchingETagConstraints
      ..clear()
      ..addAll(matchingETagConstraints ?? []);
  }

  void clearMatchingETagConstraints() {
    _matchingETagConstraints.clear();
  }

  List<String> getNonmatchingEtagConstraints() {
    return _nonmatchingEtagConstraints;
  }

  void setNonmatchingETagConstraints(List<String>? nonmatchingEtagConstraints) {
    _nonmatchingEtagConstraints
      ..clear()
      ..addAll(nonmatchingEtagConstraints ?? []);
  }

  void clearNonmatchingETagConstraints() {
    _nonmatchingEtagConstraints.clear();
  }
}
