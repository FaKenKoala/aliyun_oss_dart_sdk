import 'dart:typed_data';

import 'package:aliyun_oss_dart_sdk/src/model/web_service_request.dart';

import 'progress_listener.dart';
import 'request_progress_input_stream.dart';
import 'response_progress_input_stream.dart';

class ProgressInputStream extends InputStream {
  static InputStream inputStreamForRequest(
      InputStream inputStream, WebServiceRequest? req) {
    return req == null
        ? inputStream
        : RequestProgressInputStream(inputStream, req.progressListener);
  }

  static InputStream inputStreamForResponse(
      InputStream inputStream, WebServiceRequest? req) {
    return req == null
        ? inputStream
        : ResponseProgressInputStream(inputStream, req.progressListener);
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

  String? data;

  void close() {}

  void reset() {}

  int skip(int n) {
    return 0;
  }

  void mark(int readlimit) {}

  int available() {
    return 0;
  }

  bool markSupported() {
    return false;
  }

  int read([Uint8List? list, int? off, int? length]) {
    return 0;
  }
}

class BufferedInputStream extends InputStream {
  BufferedInputStream(InputStream inputStream) : super(inputStream);
}

class FilterInputStream extends InputStream {
  FilterInputStream(InputStream inputStream) : super(inputStream);
}

class CheckedInputStream extends FilterInputStream {
  CheckedInputStream(InputStream inputStream) : super(inputStream);
}

class BoundedInputStream extends InputStream {
  BoundedInputStream(
    InputStream inputStream,
    this.partSize,
  ) : super(inputStream);

  final int partSize;
}

class FixedLengthInputStream extends InputStream {
  FixedLengthInputStream(InputStream inputStream) : super(inputStream);

  int length = 0;
}
