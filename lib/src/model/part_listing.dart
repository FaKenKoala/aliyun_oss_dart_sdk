import 'generic_result.dart';
import 'part_summary.dart';

/// The entity class wraps the result of the list parts request.
class PartListing extends GenericResult {
  String? bucketName;

  String? key;

  String? uploadId;

  int? maxParts;

  int? partNumberMarker;

  String? storageClass;

  bool isTruncated = false;

  int? nextPartNumberMarker;

  final List<PartSummary> _parts = [];

  List<PartSummary> getParts() {
    return _parts;
  }

  void setParts(List<PartSummary>? parts) {
    _parts
      ..clear()
      ..addAll(parts ?? []);
  }

  void addPart(PartSummary partSummary) {
    _parts.add(partSummary);
  }
}
