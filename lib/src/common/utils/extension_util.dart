extension StringNullX on String? {
  bool get nullOrEmpty => this?.isEmpty ?? true;
  bool get notNullOrEmpty => !nullOrEmpty;

  apply(Function(String str) func) {
    if (this != null) {
      func(this!);
    }
  }

  bool equalsIgnoreCase(String match) {
    return this?.toLowerCase() == match.toLowerCase();
  }
}
