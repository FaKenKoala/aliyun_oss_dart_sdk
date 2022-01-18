import 'dart:math';

import 'package:aliyun_oss_dart_sdk/src/common/comm/response_message.dart';

import 'request_message.dart';

abstract class RetryStrategy {
  static const int _defaultRetryPauseScale = 300;

  bool shouldRetry(Exception ex, RequestMessage request,
      ResponseMessage response, int retries);

  int getPauseDelay(int retries) {
    int scale = _defaultRetryPauseScale;
    int delay = (pow(2, retries) * scale).toInt();
    return delay;
  }
}
