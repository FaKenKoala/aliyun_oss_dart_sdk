/// The hierarchical namespace status.
enum HnsStatus {
  Enabled,
}

extension HnsStatusX on HnsStatus {
  static HnsStatus parse(String hnsString) {
    for (HnsStatus st in HnsStatus.values) {
      if (st.name == hnsString) {
        return st;
      }
    }

    throw ArgumentError("Unable to parse $hnsString");
  }
}
