class OSSIOException implements Exception {
  dynamic message;
  OSSIOException([this.message]);

  @override
  String toString() {
    return '[OSSOSSIOException]: $message';
  }
}
