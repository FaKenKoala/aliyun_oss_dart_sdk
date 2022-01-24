import 'package:aliyun_oss_dart_sdk/src/client_error_code.dart';
import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

import 'sdk_runtime.dart';

/// Base class for OSS Java SDK specific {@link FilterInputStream}.
class SdkFilterInputStream extends FilterInputStream {
  bool aborted = false;

  SdkFilterInputStream(InputStream inputStream) : super(inputStream);

  /// Aborts the inputstream operation if thread is interrupted.
  /// interrupted status of the thread is cleared by this method.
  ///
  /// @throws ClientException with ClientErrorCode INPUTSTREAM_READING_ABORTED if thread aborted.
  void abortIfNeeded() {
    if (SdkRuntime.shouldAbort()) {
      abort();
      throw ClientException("Thread aborted, inputStream aborted...",
          ClientErrorCode.INPUTSTREAM_READING_ABORTED, null);
    }
  }

  void abort() {
    if (inputStream is SdkFilterInputStream) {
      (inputStream as SdkFilterInputStream).abort();
    }
    aborted = true;
  }

  bool isAborted() {
    return aborted;
  }

  @override
  int read([List<int>? list, int? off, int? len]) {
    abortIfNeeded();
    if (list == null) {
      return inputStream.read();
    }

    int offset = off ?? 0;
    int length = len ?? list.length;
    return inputStream.read(list, offset, length);
  }

  @override
  int skip(int n) {
    abortIfNeeded();
    return inputStream.skip(n);
  }

  @override
  int available() {
    abortIfNeeded();
    return inputStream.available();
  }

  @override
  void close() {
    inputStream.close();
    abortIfNeeded();
  }

  @override
  void mark(int readlimit) {
    abortIfNeeded();
    inputStream.mark(readlimit);
  }

  @override
  void reset() {
    abortIfNeeded();
    inputStream.reset();
  }

  @override
  bool markSupported() {
    abortIfNeeded();
    return inputStream.markSupported();
  }

  void release() {
    if (inputStream != null) {
      try {
        inputStream.close();
      } catch (ex) {
        // Ignore exception.
      }
    }
  }
}
