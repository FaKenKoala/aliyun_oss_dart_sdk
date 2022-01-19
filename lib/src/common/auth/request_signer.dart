import 'package:aliyun_oss_dart_sdk/src/common/comm/request_message.dart';

abstract class RequestSigner {
  void sign(RequestMessage request);
}
