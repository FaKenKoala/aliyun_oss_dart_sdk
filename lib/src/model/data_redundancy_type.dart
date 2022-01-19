/// Data redundancy type
// ignore_for_file: constant_identifier_names

enum DataRedundancyType {
  LRS,
  ZRS,
}

extension DataRedundancyTypeX on DataRedundancyType {
  static DataRedundancyType parse(String dataRedundancyTypeString) {
    for (DataRedundancyType e in DataRedundancyType.values) {
      if (e.name == dataRedundancyTypeString) return e;
    }
    throw ArgumentError(
        "Unsupported data redundancy type: $dataRedundancyTypeString");
  }
}
