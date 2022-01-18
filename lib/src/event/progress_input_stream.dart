import 'dart:typed_data';

import 'progress_listener.dart';
import 'request_progress_input_stream.dart';
import 'response_progress_input_stream.dart';

class ProgressInputStream extends InputStream {
  static InputStream inputStreamForRequest(
      InputStream inputStream, WebServiceRequest req) {
    return req == null
        ? inputStream
        : RequestProgressInputStream(inputStream, req.getProgressListener());
  }

  static InputStream inputStreamForResponse(
      InputStream inputStream, WebServiceRequest req) {
    return req == null
        ? inputStream
        : ResponseProgressInputStream(inputStream, req.getProgressListener());
  }

  static const defaultNotificationThreshold = 8 * 1024;

  final ProgressListener listener;
  final int notifyThresHold;

  int _unnotifiedByteCount = 0;
  bool hasBeenRead = false;
  bool doneEOF = false;
  int _notifiedByteCount = 0;

  ProgressInputStream(InputStream inputStream, this.listener,
      [this.notifyThresHold = defaultNotificationThreshold])
      : super(inputStream);

  void onFirstRead() {}

  void onEOF() {}

  void onClose() {
    _eof();
  }

  void onReset() {}

  void onNotifyBytesRead() {}

  void _onBytesRead(int bytesRead) {
    _unnotifiedByteCount += bytesRead;
    if (_unnotifiedByteCount >= notifyThresHold) {
      onNotifyBytesRead();
      _notifiedByteCount += _unnotifiedByteCount;
      _unnotifiedByteCount = 0;
    }
  }

  // @override
  //  int read()  {
  //     if (!hasBeenRead) {
  //         onFirstRead();
  //         hasBeenRead = true;
  //     }
  //     int ch = super.read();
  //     if (ch == -1)
  //         _eof();
  //     else
  //         _onBytesRead(1);
  //     return ch;
  // }

  // @override
  //  int read(Uint8List list)  {
  //     return read(list, 0, list.length);
  // }

  @override
  int read(Uint8List list, int off, int len) {
    if (!hasBeenRead) {
      onFirstRead();
      hasBeenRead = true;
    }
    int bytesRead = super.read(list, off, len);
    if (bytesRead == -1) {
      _eof();
    } else {
      _onBytesRead(bytesRead);
    }
    return bytesRead;
  }

  @override
  void reset() {
    super.reset();
    onReset();
    _unnotifiedByteCount = 0;
    _notifiedByteCount = 0;
  }

  void _eof() {
    if (doneEOF) {
      return;
    }
    onEOF();
    _unnotifiedByteCount = 0;
    doneEOF = true;
  }

  InputStream getWrappedInputStream() {
    return inputStream;
  }

  int get unnotifiedByteCount => _unnotifiedByteCount;

  int get notifiedByteCount => _notifiedByteCount;

  @override
  void close() {
    onClose();
    super.close();
  }
}

class InputStream {
  InputStream(this.inputStream);

  final InputStream inputStream;

  void close() {}

  void reset() {}

  int read(Uint8List list, int off, int length) {
    return 0;
  }
}
