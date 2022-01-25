/// 存储类型。
enum StorageClass {
  /// Standard
  Standard,

  /// Infrequent Access
  IA,

  /// Archive
  Archive,

  /// Unknown
  Unknown,
}

StorageClass parse(String storageClassString) {
  for (StorageClass st in StorageClass.values) {
    if (st.name == storageClassString) {
      return st;
    }
  }

  throw ArgumentError("Unable to parse " + storageClassString);
}
