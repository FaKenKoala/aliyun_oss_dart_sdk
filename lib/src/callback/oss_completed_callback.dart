import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/model/oss_request.dart';
import 'package:aliyun_oss_dart_sdk/src/model/oss_result.dart';
import 'package:aliyun_oss_dart_sdk/src/service_exception.dart';

abstract class OSSCompletedCallback<T1 extends OSSRequest,
    T2 extends OSSResult> {
  void onSuccess(T1 request, T2 result);

  void onFailure(T1 request, OSSClientException? clientException,
      OSSServiceException? serviceException);
}
