/// Server-side Data Encryption Algorithm.
enum DataEncryptionAlgorithm {
  SM4,
}

extension DataEncryptionAlgorithmX on DataEncryptionAlgorithm {
  static DataEncryptionAlgorithm? fromString(String? algorithm) {
    if (algorithm == null) {
      return null;
    }
    for (DataEncryptionAlgorithm e in DataEncryptionAlgorithm.values) {
      if (e.name == algorithm) {
        return e;
      }
    }
    throw ArgumentError("Unsupported data encryption algorithm $algorithm");
  }
}
