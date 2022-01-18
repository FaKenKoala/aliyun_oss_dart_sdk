import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

class HttpMessage {
  Map<String, String> headers = <String, String>{};
  InputStream? content;
  int? contentLength;

  void close() {
    content?.close();
    content = null;
  }
}
