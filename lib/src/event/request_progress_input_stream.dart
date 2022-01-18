import 'progress_input_stream.dart';
import 'progress_listener.dart';
import 'progress_publisher.dart';

class RequestProgressInputStream extends ProgressInputStream {
  RequestProgressInputStream(InputStream inputStream, ProgressListener listener)
      : super(inputStream, listener);

  @override
  void onEOF() {
    onNotifyBytesRead();
  }

  @override
  void onNotifyBytesRead() {
    ProgressPublisher.publishRequestBytesTransferred(
        listener, unnotifiedByteCount);
  }
}
