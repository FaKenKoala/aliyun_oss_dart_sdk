import 'dart:math';
import 'dart:typed_data';

import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

/// This is a stream that will only supply bytes up to a certain length - if its
/// position goes above that, it will stop.
/// <p>
/// This is useful to wrap ServletInputStreams. The ServletInputStream will block
/// if you try to read content from it that isn't there, because it doesn't know
/// whether the content hasn't arrived yet or whether the content has finished.
/// So, one of these, initialized with the Content-length sent in the
/// ServletInputStream's header, will stop it blocking, providing it's been sent
/// with a correct content length.
///
/// @since 2.1.1
class BoundedInputStream extends InputStream {
  /// the max length to provide */
  final int max;

  /// the number of bytes already returned */
  int pos = 0;

  /// the marked position */
  int _mark = -1;

  /// flag if close shoud be propagated */
  bool propagateClose = true;

  /// Creates a new <code>BoundedInputStream</code> that wraps the given input
  /// stream and limits it to a certain size.
  ///
  /// @param in
  ///            The wrapped input stream
  /// @param size
  ///            The maximum number of bytes to return
  BoundedInputStream(InputStream inputStream, [this.max = -1])
      : super(inputStream);

  /// Invokes the delegate's <code>read(byte[], int, int)</code> method.
  ///
  /// @param b
  ///            the buffer to read the bytes into
  /// @param off
  ///            The start offset
  /// @param len
  ///            The number of bytes to read
  /// @return the number of bytes read or -1 if the end of stream or the limit
  ///         has been reached.
  /// @throws IOException
  ///             if an I/O error occurs
  @override
  int read([Uint8List? list, int? offset, int? length]) {
    if (list == null) {
      if (max >= 0 && pos >= max) {
        return -1;
      }
      int result = inputStream.read();
      pos++;
      return result;
    }

    int off = offset ?? 0;
    int len = length ?? list.length;

    if (max >= 0 && pos >= max) {
      return -1;
    }
    int maxRead = max >= 0 ? min(len, max - pos) : len;
    int bytesRead = inputStream.read(list, off, maxRead);

    if (bytesRead == -1) {
      return -1;
    }

    pos += bytesRead;
    return bytesRead;
  }

  /// Invokes the delegate's <code>skip(int)</code> method.
  ///
  /// @param n
  ///            the number of bytes to skip
  /// @return the actual number of bytes skipped
  /// @throws IOException
  ///             if an I/O error occurs
  @override
  int skip(int n) {
    int toSkip = max >= 0 ? min(n, max - pos) : n;
    int skippedBytes = inputStream.skip(toSkip);
    pos += skippedBytes;
    return skippedBytes;
  }

  /// {@inheritDoc}
  @override
  int available() {
    if (max >= 0 && pos >= max) {
      return 0;
    }
    return inputStream.available();
  }

  /// Invokes the delegate's <code>toString()</code> method.
  ///
  /// @return the delegate's <code>toString()</code>
  @override
  String toString() {
    return inputStream.toString();
  }

  /// Invokes the delegate's <code>close()</code> method if
  /// {@link #isPropagateClose()} is {@code true}.
  ///
  /// @throws IOException
  ///             if an I/O error occurs
  @override
  void close() {
    if (propagateClose) {
      inputStream.close();
    }
  }

  /// Invokes the delegate's <code>reset()</code> method.
  ///
  /// @throws IOException
  ///             if an I/O error occurs
  @override
  void reset() {
    inputStream.reset();
    pos = _mark;
  }

  /// Invokes the delegate's <code>mark(int)</code> method.
  ///
  /// @param readlimit
  ///            read ahead limit
  @override
  void mark(int readlimit) {
    inputStream.mark(readlimit);
    _mark = pos;
  }

  /// Invokes the delegate's <code>markSupported()</code> method.
  ///
  /// @return true if mark is supported, otherwise false
  @override
  bool markSupported() {
    return inputStream.markSupported();
  }

  /// Go back current position
  ///
  /// @param backoff
  void backoff(int backoff) {
    pos -= backoff;
  }
}
