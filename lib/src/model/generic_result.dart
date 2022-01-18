import 'package:aliyun_oss_dart_sdk/src/common/comm/response_message.dart';

class GenericResult {
  String? requestId;
  int? clientCRC;
  int? serverCRC;
  ResponseMessage? response;
}
