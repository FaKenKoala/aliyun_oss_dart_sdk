import 'package:aliyun_oss_dart_sdk/src/common/utils/http_headers.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/log_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_listener.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_publisher.dart';
import 'package:aliyun_oss_dart_sdk/src/model/web_service_request.dart';

import 'request_handler.dart';
import 'request_message.dart';

class RequestProgressHanlder implements RequestHandler {
  @override
  void handle(RequestMessage request) {
    final WebServiceRequest originalRequest = request.originalRequest;
    final ProgressListener listener = originalRequest.progressListener;
    Map<String, String> headers = request.headers;
    String? s = headers[HttpHeaders.contentLength];
    if (s != null) {
      try {
        int contentLength = int.parse(s);
        ProgressPublisher.publishRequestContentLength(listener, contentLength);
      } on FormatException catch (e) {
        LogUtils.logException(
            "Cannot parse the Content-Length header of the request: ", e);
      }
    }

    InputStream? content = request.content;
    if (content == null) {
      return;
    }
    if (!content.markSupported()) {
      content = BufferedInputStream(content);
    }
    request.content = listener == ProgressListener.noop
        ? content
        : ProgressInputStream.inputStreamForRequest(content!, originalRequest);
  }
}
