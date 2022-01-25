import 'common/oss_log.dart';

class OSSClientException implements Exception {
  final bool _canceled;
  dynamic message;

  /// Constructor with error message, exception instance and isCancelled flag
  OSSClientException(this.message, [this._canceled = false]) {
    OSSLog.logThrowable2Local(this);
  }

  /// Checks if the exception is due to the cancellation
  ///
  /// @return
  bool isCanceledException() {
    return _canceled;
  }

  @override
  String toString() {
    return '[ErrorMessage: $message';
  }
}
