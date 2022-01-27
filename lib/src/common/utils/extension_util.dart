extension StringNullX on String? {
  bool get isNullOrEmpty => this?.isEmpty ?? true;
  bool get notNullOrEmpty => !isNullOrEmpty;

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
