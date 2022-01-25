class TaskCancelException implements Exception {
  
  TaskCancelException(this.message);
  
  final dynamic message;
  
  @override
  String toString() {
    return "[ErrorMessage]: $message";
  }
}
