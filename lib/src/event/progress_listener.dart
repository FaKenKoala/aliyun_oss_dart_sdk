import 'progress_event.dart';

abstract class ProgressListener {
  void progressChanged(ProgressEvent progressEvent);

  static final ProgressListener noop = _Noop();
}

class _Noop implements ProgressListener {
  @override
  void progressChanged(ProgressEvent progressEvent) {}
}
