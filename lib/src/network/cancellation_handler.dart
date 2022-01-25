import 'package:dio/dio.dart';

class CancellationHandler {
  bool _isCancelled = false;

  CancelToken? call;

  void cancel() {
    call?.cancel();
    _isCancelled = true;
  }

  bool get isCancelled {
    return _isCancelled;
  }
}
