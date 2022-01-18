import 'service_exception.dart';

/// The OSSException is thrown upon error when accessing OSS.
class OSSException extends ServiceException {
  String? resourceType;
  String? header;
  String? method;

  OSSException({
    String? errorMessage,
    String? errorCode,
    String? requestId,
    String? hostId,
    String? rawResponseError,
    this.header,
    this.resourceType,
    this.method,
  }) : super(
            errorMessage: errorMessage,
            errorCode: errorCode,
            requestId: requestId,
            hostId: hostId,
            rawResponseError: rawResponseError);

  @override
  String getMessage() {
    return super.getMessage() +
        (resourceType == null ? "" : "\n[ResourceType]: $resourceType") +
        (header == null ? "" : "\n[Header]: $header") +
        (method == null ? "" : "\n[Method]: $method");
  }
}
