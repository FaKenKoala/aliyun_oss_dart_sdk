import 'payer.dart';
import 'web_service_request.dart';

/// Options for checking if the object key exists under the specified bucket.
class HeadObjectRequest extends WebServiceRequest {
  String? bucketName;
  String? key;

  final List<String> _matchingETagConstraints = [];
  final List<String> _nonmatchingETagConstraints = [];
  DateTime? unmodifiedSinceConstraint;
  DateTime? modifiedSinceConstraint;

  // The object version id
  String? versionId;

  // The one who pays for the request
  Payer? payer;

  HeadObjectRequest(this.bucketName, this.key, [this.versionId]);

  List<String> getMatchingETagConstraints() {
    return _matchingETagConstraints;
  }

  void setMatchingETagConstraints(List<String>? matchingETagConstraints) {
    _matchingETagConstraints
      ..clear()
      ..addAll(matchingETagConstraints ?? []);
  }

  List<String> getNonmatchingETagConstraints() {
    return _nonmatchingETagConstraints;
  }

  void setNonmatchingETagConstraints(List<String>? nonmatchingETagConstraints) {
    _nonmatchingETagConstraints
      ..clear()
      ..addAll(nonmatchingETagConstraints ?? []);
  }
}
