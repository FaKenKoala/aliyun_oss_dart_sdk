import 'progress_event.dart';
import 'progress_event_type.dart';
import 'progress_listener.dart';

class ProgressPublisher {
  static void publishProgress(
      final ProgressListener? listener, final ProgressEventType? eventType) {
    if (listener == ProgressListener.noop ||
        listener == null ||
        eventType == null) {
      return;
    }
    listener.progressChanged(ProgressEvent(eventType));
  }

  static void publishSelectProgress(final ProgressListener? listener,
      final ProgressEventType? eventType, final int scannedBytes) {
    if (listener == ProgressListener.noop ||
        listener == null ||
        eventType == null) {
      return;
    }
    listener.progressChanged(ProgressEvent(eventType, scannedBytes));
  }

  static void publishRequestContentLength(
      final ProgressListener? listener, final int bytes) {
    publishByteCountEvent(
        listener, ProgressEventType.requestContentLengthEvent, bytes);
  }

  static void publishRequestBytesTransferred(
      final ProgressListener? listener, final int bytes) {
    publishByteCountEvent(
        listener, ProgressEventType.requestByteTransferEvent, bytes);
  }

  static void publishResponseContentLength(
      final ProgressListener? listener, final int bytes) {
    publishByteCountEvent(
        listener, ProgressEventType.responseContentLengthEvent, bytes);
  }

  static void publishResponseBytesTransferred(
      final ProgressListener? listener, final int bytes) {
    publishByteCountEvent(
        listener, ProgressEventType.responseByteTransferEvent, bytes);
  }

  static void publishByteCountEvent(final ProgressListener? listener,
      final ProgressEventType eventType, final int bytes) {
    if (listener == ProgressListener.noop || listener == null || bytes <= 0) {
      return;
    }
    listener.progressChanged(ProgressEvent(eventType, bytes));
  }
}
