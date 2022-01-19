import 'payer.dart';
import 'web_service_request.dart';

class UploadPartCopyRequest extends WebServiceRequest {
  String? bucketName;

  String? key;

  String? sourceBucketName;

  String? sourceKey;

  String? uploadId;

  int partNumber = 0;

  int? partSize;

  String? md5Digest;

  int? beginIndex;

  final List<String> _matchingETagConstraints = [];

  final List<String> _nonmatchingEtagConstraints = [];

  DateTime? unmodifiedSinceConstraint;

  DateTime? modifiedSinceConstraint;

  /// Optional version Id specifying which version of the source object to
  /// copy. If not specified, the most recent version of the source object will
  /// be copied.
  String? sourceVersionId;

  // The one who pays for the request
  Payer? payer;

  UploadPartCopyRequest(
      [this.sourceBucketName,
      this.sourceKey,
      this.bucketName,
      this.key,
      this.uploadId,
      this.partNumber = 0,
      this.beginIndex,
      this.partSize]);

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
