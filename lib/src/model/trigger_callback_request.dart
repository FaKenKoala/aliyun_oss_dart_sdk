import 'oss_request.dart';

class TriggerCallbackRequest extends OSSRequest {
  String bucketName;

  String objectKey;

  Map<String, String> callbackParam;

  Map<String, String> callbackVars;

  TriggerCallbackRequest(
      this.bucketName, this.objectKey, this.callbackParam, this.callbackVars);
}
