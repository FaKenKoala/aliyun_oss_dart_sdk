import 'package:aliyun_oss_dart_sdk/src/model/lib_model.dart';
import 'package:aliyun_oss_dart_sdk/src/model/oss_request.dart';

abstract class Callable<Result extends OSSResult> {
  Result call();
}
