import 'oss_object_summary.dart';
import 'oss_result.dart';

class ListObjectsResult extends OSSResult {
  /// A list of summary information describing the objects stored in the bucket
  List<OSSObjectSummary> _objectSummaries = [];

  List<String> _commonPrefixes = [];

  String? bucketName;

  String? nextMarker;

  bool isTruncated = false;

  String? prefix;

  String? marker;

  int maxKeys = 100;

  String? delimiter;

  String? encodingType;

  List<OSSObjectSummary> getObjectSummaries() {
    return _objectSummaries;
  }

  void addObjectSummary(OSSObjectSummary objectSummary) {
    _objectSummaries.add(objectSummary);
  }

  void clearObjectSummaries() {
    _objectSummaries.clear();
  }

  List<String> getCommonPrefixes() {
    return _commonPrefixes;
  }

  void addCommonPrefix(String commonPrefix) {
    _commonPrefixes.add(commonPrefix);
  }

  void clearCommonPrefixes() {
    _commonPrefixes.clear();
  }
}
