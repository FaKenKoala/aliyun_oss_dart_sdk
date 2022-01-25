import 'oss_result.dart';
import 'part_summary.dart';

class ListPartsResult extends OSSResult {
  String? bucketName;

  String? key;

  String? uploadId;

  int maxParts = 0;

  int partNumberMarker = 0;

  String? storageClass;

  bool isTruncated = false;

  int nextPartNumberMarker = 0;

  final List<PartSummary> _parts = [];

  List<PartSummary> getParts() {
    return _parts;
  }

  void setParts(List<PartSummary>? parts) {
    _parts
      ..clear()
      ..addAll(parts ?? []);
  }
}
