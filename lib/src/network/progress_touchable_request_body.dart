import 'dart:math';

import 'package:aliyun_oss_dart_sdk/src/callback/lib_callback.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/lib_internal.dart';
import 'package:aliyun_oss_dart_sdk/src/model/lib_model.dart';

class ProgressTouchableRequestBody<T extends OSSRequest> extends RequestBody {
  static final int SEGMENT_SIZE = 2048; // okio.Segment.SIZE

  InputStream inputStream;
  final String contentType;
  final int contentLength;
  OSSProgressCallback callback;
  T request;

  ProgressTouchableRequestBody(
      this.inputStream, this.contentLength, this.contentType);


  @override
  void writeTo(BufferedSink sink) {
    Source source = Okio.source(inputStream);
    int total = 0;
    int read, toRead, remain;

    while (total < contentLength) {
      remain = contentLength - total;
      toRead = min(remain, SEGMENT_SIZE);

      read = source.read(sink.buffer(), toRead);
      if (read == -1) {
        break;
      }

      total += read;
      sink.flush();

      if (callback != null && total != 0) {
        callback.onProgress(request, total, contentLength);
      }
    }
    if (source != null) {
      source.close();
    }
  }
}
