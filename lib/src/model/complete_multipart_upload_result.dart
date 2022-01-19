import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

import 'callback_result.dart';
import 'generic_result.dart';

/// The result of a multipart upload.
class CompleteMultipartUploadResult extends GenericResult
    implements CallbackResult {
  /// The name of the bucket containing the completed multipart upload.
  String? bucketName;

  /// The key by which the object is stored.
  String? key;

  /// The URL identifying the new multipart object.
  String? location;

  String? eTag;

  /// Object Version Id.
  String? versionId;

  /// The callback request's response body
  InputStream? _callbackResponseBody;

  @override
  InputStream? getCallbackResponseBody() {
    return _callbackResponseBody;
  }

  @override
  void setCallbackResponseBody(InputStream callbackResponseBody) {
    _callbackResponseBody = callbackResponseBody;
  }
}
