enum SubDirType {
  /// the owner of the bucket
  redirect,
  noSuchKey,
  $index,
}

extension SubDirTypeX on SubDirType {
  static SubDirType parse(String payerString) {
    for (SubDirType type in SubDirType.values) {
      if (type.index.toString() == payerString) {
        return type;
      }
    }
    throw ArgumentError("Unable to parse $payerString");
  }
}
