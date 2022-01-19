/// <p>
/// This exception is the one thrown by the client side when accessing OSS.
/// </p>
///
/// <p>
/// {@link ClientException} is the class to represent any exception in OSS client
/// side. Generally ClientException occurs either before sending the request or
/// after receving the response from OSS server side. For example, if the network
/// is broken when it tries to send a request, then the SDK will throw a
/// {@link ClientException} instance.
/// </p>
///
/// <p>
/// {@link ServiceException} is converted from error code from OSS response. For
/// example, when OSS tries to authenticate a request, if Access ID does not
/// exist, the SDK will throw a {@link ServiceException} or its subclass instance
/// with the specific error code, which the caller could handle that with
/// specific logic.
/// </p>
///
class ClientException implements Exception {
  ClientException([
    this.errorMessage,
    this.errorCode,
    this.requestId,
  ]);

  String? errorMessage;
  String? requestId;
  String? errorCode;

  String getMessage() {
    return "$errorMessage\n[ErrorCode]: ${errorCode ?? ""}\n[RequestId]: ${requestId ?? ""}";
  }
}
