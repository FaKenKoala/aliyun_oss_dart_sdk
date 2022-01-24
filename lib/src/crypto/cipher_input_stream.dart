import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

import 'crypto_cipher.dart';
import 'sdk_filter_input_stream.dart';

class CipherInputStream extends SdkFilterInputStream {
  static const int MAX_RETRY = 1000;
  static const int DEFAULT_IN_BUFFER_SIZE = 512;
  CryptoCipher cryptoCipher;
  bool eof = false;
  List<int> bufin = [];
  List<int>? bufout;
  int curr_pos = 0;
  int max_pos = 0;

  CipherInputStream(InputStream inputStream, this.cryptoCipher,
      [int buffsize = DEFAULT_IN_BUFFER_SIZE])
      : super(inputStream) {
    if (buffsize <= 0 || (buffsize % DEFAULT_IN_BUFFER_SIZE) != 0) {
      throw ArgumentError(
          "buffsize ($buffsize) must be a positive multiple of $DEFAULT_IN_BUFFER_SIZE");
    }
    bufin = List.filled(buffsize, 0);
  }

  @override
  int read([List<int>? list, int? off, int? len]) {
    if (curr_pos >= max_pos) {
      if (eof) {
        return -1;
      }
      int count = 0;
      int len;
      do {
        if (count > MAX_RETRY) {
          throw Exception(
              "exceeded maximum number of attempts to read next chunk of data");
        }
        len = nextChunk();
        count++;
      } while (len == 0);

      if (len == -1) {
        return -1;
      }
    }

    if (list == null) {
      return bufout![curr_pos++] & 0xFF;
    }

    int offset = off ?? 0;
    int length = len ?? list.length;

    if (length <= 0) {
      return 0;
    }
    int lenResult = max_pos - curr_pos;
    if (length < lenResult) {
      lenResult = length;
    }
    System.arraycopy(bufout, curr_pos, list, offset, len);
    curr_pos += lenResult;
    return lenResult;
  }

  /// Note: This implementation will only skip up to the end of the buffered data,
  /// potentially skipping 0 bytes.
  @override
  int skip(int n) {
    abortIfNeeded();
    int available = max_pos - curr_pos;
    if (n > available) {
      n = available;
    }
    if (n < 0) {
      return 0;
    }
    curr_pos += n;
    return n;
  }

  @override
  int available() {
    abortIfNeeded();
    return max_pos - curr_pos;
  }

  @override
  void close() {
    inputStream.close();
    try {
      cryptoCipher.doFinal();
    } catch (ex) {}
    curr_pos = max_pos = 0;
    abortIfNeeded();
  }

  @override
  bool markSupported() {
    abortIfNeeded();
    return false;
  }

  @override
  void mark(int readlimit) {
    abortIfNeeded();
  }

  @override
  void reset() {
    throw StateError("mark/reset not supported.");
  }

  void resetInternal() {
    curr_pos = max_pos = 0;
    eof = false;
  }

  /// Reads and process the next chunk of data into memory.
  ///
  /// @return the length of the data chunk read and processed, or -1 if end of
  ///         stream.
  /// @throws IOException
  ///             if there is an IO exception from the underlying input stream
  ///
  /// @throws SecurityException
  ///             if there is authentication failure
  int nextChunk() {
    abortIfNeeded();
    if (eof) {
      return -1;
    }
    bufout = null;
    int len = inputStream.read(bufin);
    if (len == -1) {
      eof = true;
      try {
        bufout = cryptoCipher.doFinal();
        if (bufout == null) {
          return -1;
        }
        curr_pos = 0;
        return max_pos = bufout!.length;
      } catch (e) {
        throw SecurityException(e);
      }
      return -1;
    }
    bufout = cryptoCipher.update(bufin, 0, len);
    curr_pos = 0;
    return max_pos = (bufout == null ? 0 : bufout.length);
  }

  void renewCryptoCipher() {
    cryptoCipher = cryptoCipher.recreate();
  }
}
