extension StringNullX on String? {
  bool get nullOrEmpty => this?.isEmpty ?? true;
  bool get notNullOrEmpty => !nullOrEmpty;

  bool equalsIgnoreCase(String match) {
    return this?.toLowerCase() == match.toLowerCase();
  }
}

extension ObjectX on Object? {
  apply(Function(dynamic) func) {
    if (this != null) {
      return func(this);
    }
  }
}
