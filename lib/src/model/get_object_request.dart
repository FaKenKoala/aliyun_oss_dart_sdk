import 'generic_request.dart';
import 'response_header_overrides.dart';

/// This is the request class that is used to download an object from OSS. It
/// wraps all the information needed to download an object.

class GetObjectRequest extends GenericRequest {
  List<String> matchingETagConstraints = [];
  List<String> nonmatchingEtagConstraints = [];
  DateTime? unmodifiedSinceConstraint;
  DateTime? modifiedSinceConstraint;
  String? process;

  List<int> _range = [];

  ResponseHeaderOverrides? responseHeaders;

  /// Fields releated with getobject operation by using url signature.
  Uri? absoluteUrl;
  bool useUrlSignature = false;

  // Traffic limit speed, its uint is bit/s
  int trafficLimit = 0;

  GetObjectRequest({
    String? bucketName,
    String? key,
    String? versionId,
    this.absoluteUrl,
    Map<String, String>? requestHeaders,
  }) : super(
          bucketName: bucketName,
          key: key,
          versionId: versionId,
        ) {
    if (absoluteUrl != null) {
      useUrlSignature = true;
      headers
        ..clear()
        ..addAll(requestHeaders ?? {});
    }
  }

  List<int> getRange() => _range;
  void setRange(int start, int end) {
    _range = [start, end];
  }

  /// the object's ETag, the file would be downloaded. Otherwise, return
  /// precondition failure (412).
  void setMatchingETagConstraints(List<String>? eTagList) {
    matchingETagConstraints
      ..clear()
      ..addAll(eTagList ?? []);
  }

  void clearMatchingETagConstraints() {
    matchingETagConstraints.clear();
  }

  /// Sets the non-matching Etag constraints. If the first ETag returned does
  /// not match the object's ETag, the file would be downloaded. Currently OSS
  /// only supports one ETag. Otherwise, returns precondition failure (412).
  void setNonmatchingETagConstraints(List<String>? eTagList) {
    nonmatchingEtagConstraints
      ..clear()
      ..addAll(eTagList ?? []);
  }

  void clearNonmatchingETagConstraints() {
    nonmatchingEtagConstraints.clear();
  }
}
