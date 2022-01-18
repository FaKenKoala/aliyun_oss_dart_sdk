import 'progress_input_stream.dart';
import 'progress_listener.dart';
import 'progress_publisher.dart';

class ResponseProgressInputStream extends ProgressInputStream {

     ResponseProgressInputStream(InputStream inputStream, ProgressListener listener) 
    :    super(inputStream, listener);
    

    @override
     void onEOF() {
        onNotifyBytesRead();
    }

    @override
     void onNotifyBytesRead() {
        ProgressPublisher.publishResponseBytesTransferred(listener, unnotifiedByteCount);
    }
}