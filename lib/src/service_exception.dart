class ServiceException implements Exception {
  ServiceException({
    this.errorMessage,
    this.errorCode,
    this.requestId,
    this.hostId,
    this.rawResponseError,
  });

  String? errorMessage;
  String? errorCode;
  String? requestId;
  String? hostId;

  String? rawResponseError;

  String formatRawResponseError() {
    if (rawResponseError == null || rawResponseError == "") {
      return "";
    }
    return "\n[ResponseError]:\n$rawResponseError";
  }

  String getMessage() {
    return "$errorMessage\n[ErrorCode]: $errorCode\n[RequestId]: $requestId\n[HostId]: $hostId${formatRawResponseError()}";
  }
}
