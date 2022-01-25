class Range {
  static const int infinite = -1;

  /// The start point of the download range
  int begin;

  /// The end point of the download range
  int end;

  /// Constructor
  ///
  /// @param begin The start index
  /// @param end   The end index
  Range(this.begin, this.end);

  bool checkIsValid() {
    if (begin < -1 || end < -1) {
      return false;
    }
    if (begin >= 0 && end >= 0 && begin > end) {
      return false;
    }
    return true;
  }

  @override
  String toString() {
    return "bytes=${begin == -1 ? '' : begin}-${end == -1 ? '' : end}";
  }
}
