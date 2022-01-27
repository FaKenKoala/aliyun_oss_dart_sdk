class InterruptedException implements Exception {
  dynamic message;
  InterruptedException(this.message);

  @override
  String toString() {
    return '[InterruptedException]: $message';
  }
}
