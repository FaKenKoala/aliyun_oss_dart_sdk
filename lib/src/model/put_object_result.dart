import 'oss_result.dart';

class PutObjectResult extends OSSResult {
  // Object ETag
  String? eTag;

  // The callback response if the servercallback is specified
  String? serverCallbackReturnBody;
}
