///
/// The storage class.
///
// ignore_for_file: constant_identifier_names

enum StorageClass {
  /// Standard
  Standard,

  /// Infrequent Access
  IA,

  /// Archive
  Archive,

  /// ColdArchive
  ColdArchive,

  /// Unknown
  Unknown,
}

extension StorageClassX on StorageClass {
  static StorageClass parse(String storageClassString) {
    for (StorageClass st in StorageClass.values) {
      if (st.name == storageClassString) {
        return st;
      }
    }

    throw ArgumentError("Unable to parse $storageClassString");
  }
}
