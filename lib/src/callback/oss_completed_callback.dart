import 'package:aliyun_oss_dart_sdk/src/model/lib_model.dart';

abstract class OSSCompletedCallback<T1 extends OSSRequest,
    T2 extends OSSResult> {
  void onSuccess(T1 request, T2 result);

  void onFailure(T1 request, OSSClientException clientException,
      OSSServiceException serviceException);
}
