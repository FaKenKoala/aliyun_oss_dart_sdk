import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

/// The result of the callback.
abstract class CallbackResult {
  /// Gets the response body of the callback request. The caller needs to close
  /// it after usage.
  InputStream? get callbackResponseBody;

  /// Sets the callback response body.
  set callbackResponseBody(InputStream? callbackResponseBody);
}
