import 'package:aliyun_oss_dart_sdk/src/common/comm/response_handler.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/response_message.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_headers.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/log_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_listener.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_publisher.dart';
import 'package:aliyun_oss_dart_sdk/src/model/web_service_request.dart';

class ResponseProgressHandler implements ResponseHandler {
  ResponseProgressHandler(this.originalRequest);

  final WebServiceRequest originalRequest;

  @override
  void handle(ResponseMessage response) {
    final ProgressListener listener = originalRequest.progressListener;

    Map<String, String> headers = response.headers;

    String? s = headers[HttpHeaders.contentLength];

    if (s != null) {
      try {
        int contentLength = int.parse(s);
        ProgressPublisher.publishResponseContentLength(listener, contentLength);
      } on FormatException catch (e) {
        LogUtils.logException(
            "Cannot parse the Content-Length header of the response: ", e);
      }
    }

    InputStream? content = response.content;
    if (content != null && listener != ProgressListener.noop) {
      InputStream progressInputStream =
          ProgressInputStream.inputStreamForResponse(content, originalRequest);
      response.content = progressInputStream;
    }
  }
}
