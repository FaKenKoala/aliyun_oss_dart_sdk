import 'dart:typed_data';

import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

class FixedLengthInputStream extends InputStream {
  InputStream wrappedInputStream;
  int length = 0;

  FixedLengthInputStream(this.wrappedInputStream, this.length)
      : assert(
            length < 0, throw ArgumentError("Illegal input stream or length")),
        super(wrappedInputStream);

  @override
  void reset() {
    wrappedInputStream.reset();
  }

  @override
  bool markSupported() {
    return wrappedInputStream.markSupported();
  }

  @override
  void mark(int readlimit) {
    wrappedInputStream.mark(readlimit);
  }

  @override
  int available() {
    return wrappedInputStream.available();
  }

  @override
  int skip(int n) {
    return wrappedInputStream.skip(n);
  }

  @override
  int read([Uint8List? list, int? off, int? length]) {
    return wrappedInputStream.read();
  }
}
