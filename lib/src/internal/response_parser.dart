import 'package:aliyun_oss_dart_sdk/src/model/lib_model.dart';

import 'response_message.dart';

abstract class ResponseParser<T extends OSSResult> {
  T parse(ResponseMessage response);
}
