import 'package:aliyun_oss_dart_sdk/src/common/comm/response_message.dart';

abstract class ResponseParser<T> {
  T parse(ResponseMessage response);
}
