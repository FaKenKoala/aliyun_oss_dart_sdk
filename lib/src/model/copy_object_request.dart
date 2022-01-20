import 'object_metadata.dart';
import 'payer.dart';
import 'web_service_request.dart';

/// The request class that is used to copy an object. It wraps all parameters
/// needed to copy an object.
class CopyObjectRequest extends WebServiceRequest {
  // Source bucket name.
  String sourceBucketName;

  // Source object key.
  String sourceKey;

  // Optional version Id specifying which version of the source object to
  // copy. If not specified, the most recent version of the source object will
  // be copied.
  String? sourceVersionId;

  // Target bucket name.
  String destinationBucketName;

  // Target object key.
  String destinationKey;

  // Target server's encryption algorithm.
  String? serverSideEncryption;

  // Target server's encryption key ID.
  String? serverSideEncryptionKeyID;

  // Target object's metadata information.
  ObjectMetadata? newObjectMetadata;

  // ETag matching Constraints. The copy only happens when source object's
  // ETag matches the specified one.
  // If not matches, return 412.
  // It's optional.
  final List<String> _matchingETagConstraints = [];

  // ETag non-matching Constraints. The copy only happens when source object's
  // ETag does not match the specified one.
  // If matches, return 412.
  // It's optional.
  final List<String> _nonmatchingEtagConstraints = [];

  // If the specified time is same or later than the actual last modified
  // time, copy the file.
  // Otherwise return 412.
  // It's optional.
  DateTime? unmodifiedSinceConstraint;

  // If the specified time is earlier than the actual last modified time, copy
  // the file.
  // Otherwise return 412. It's optional.
  DateTime? modifiedSinceConstraint;

  // The one who pays for the request
  Payer? payer;

  CopyObjectRequest(
    this.sourceBucketName,
    this.sourceKey,
    this.destinationBucketName,
    this.destinationKey, [
    this.sourceVersionId,
  ]);
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
