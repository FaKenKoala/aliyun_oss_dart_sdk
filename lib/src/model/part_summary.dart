/// The multipart upload's part summary class definition
class PartSummary {
  int partNumber = -1;

  DateTime? lastModified;

  String? eTag;

  int size = 0;
}
