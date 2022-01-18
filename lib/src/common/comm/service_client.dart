import 'package:aliyun_oss_dart_sdk/src/common/comm/http_message.dart';
import 'package:aliyun_oss_dart_sdk/src/http_method.dart';

abstract class ServiceClient {}

class Request extends HttpMessage {
  String? uri;
  HttpMethod? method;
  bool useUrlSignature = false;
  bool useChunkEncoding = false;
}
