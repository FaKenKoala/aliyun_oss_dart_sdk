import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

import 'callback_result.dart';
import 'generic_result.dart';

/// The result class of a Put Object request.
class PutObjectResult extends GenericResult implements CallbackResult {
  // Object ETag
  String? eTag;

  // Object Version Id
  String? versionId;

  // The callback response body. Caller needs to close it.
  InputStream? _callbackResponseBody;

  @override
  InputStream? get callbackResponseBody {
    return _callbackResponseBody;
  }

  @override
  set callbackResponseBody(InputStream? callbackResponseBody) {
    _callbackResponseBody = callbackResponseBody;
  }
}
