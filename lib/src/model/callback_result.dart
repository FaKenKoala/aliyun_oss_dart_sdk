import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

/// The result of the callback.
abstract class CallbackResult {
  /// Gets the response body of the callback request. The caller needs to close
  /// it after usage.
  ///
  /// @return The {@link InputStream} instance of the response body.
  InputStream getCallbackResponseBody();

  /// Sets the callback response body.
  ///
  /// @param callbackResponseBody
  ///           The {@link InputStream} instance of the response body.
  ///
  void setCallbackResponseBody(InputStream callbackResponseBody);
}
