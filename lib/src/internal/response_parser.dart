import 'package:aliyun_oss_dart_sdk/src/model/oss_result.dart';
import 'response_message.dart';

abstract class ResponseParser<T extends OSSResult> {
  T parse(ResponseMessage response);
}
