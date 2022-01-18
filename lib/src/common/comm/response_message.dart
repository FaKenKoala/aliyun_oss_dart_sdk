import 'package:aliyun_oss_dart_sdk/src/common/comm/http_message.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/oss_headers.dart';

import 'service_client.dart';

class ResponseMessage extends HttpMessage {
  static const int _httpSuccessStatusCode = 20;

  String? uri;
  late int statusCode;

  Request request;

  /// TODO: wombat: 可以关闭的响应
  CloseableHttpResponse? httpResponse;

  String? errorResponseAsString;

  ResponseMessage(this.request);

  String? getRequestId() {
    return headers[OSSHeaders.ossHeaderRequestId];
  }

  bool isSuccessful() {
    return statusCode / 100 == _httpSuccessStatusCode / 100;
  }

  void abort() {
    httpResponse?.close();
  }
}

class CloseableHttpResponse {
  void close() {}
}
