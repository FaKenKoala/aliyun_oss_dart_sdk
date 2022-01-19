/// Server-side Encryption Algorithm.
// ignore_for_file: constant_identifier_names

enum SSEAlgorithm {
  AES256,
  KMS,
  SM4,
}

extension SSEAlgorithmX on SSEAlgorithm {
  static SSEAlgorithm? fromString(String? algorithm) {
    if (algorithm == null) {
      return null;
    }
    for (SSEAlgorithm e in SSEAlgorithm.values) {
      if (e.name == algorithm) {
        return e;
      }
    }
    throw ArgumentError("Unsupported algorithm $algorithm");
  }

  /// Returns the default server side encryption algorithm, which is AES256.
  static SSEAlgorithm getDefault() {
    return SSEAlgorithm.AES256;
  }
}
