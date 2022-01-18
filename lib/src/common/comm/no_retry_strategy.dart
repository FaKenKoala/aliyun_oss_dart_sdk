import 'package:aliyun_oss_dart_sdk/src/common/comm/response_message.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/retry_strategy.dart';

class NoRetryStrategy extends RetryStrategy {
  @override
  bool shouldRetry(
      Exception ex, request, ResponseMessage response, int retries) {
    return false;
  }
}
