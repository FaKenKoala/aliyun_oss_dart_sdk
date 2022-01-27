import 'common/oss_log.dart';

class OSSServiceException implements Exception {
  OSSServiceException(this.statusCode, this.message, this.errorCode,
      this.requestId, this.hostId, this.rawMessage) {
    OSSLog.logThrowable2Local(this);
  }
  static final String PARSE_RESPONSE_FAIL = "SDKParseResponseFail";

  /// http status code
  final int statusCode;

  /// exception
  final dynamic message;

  /// OSS error code, check out：http://help.aliyun.com/document_detail/oss/api-reference/error-response.html
  final String? errorCode;

  /// OSS request Id
  final String? requestId;

  /// The OSS host Id which is same as the one in the request
  final String? hostId;

  /// The raw message in the response
  final String? rawMessage;

  /// part number
  String? partNumber;

  /// part etag
  String? partEtag;

  @override
  String toString() {
    return "[StatusCode]: $statusCode, [Code]: $errorCode, [Message]: $message, [Requestid]: $requestId, [HostId]: $hostId, [RawMessage]: $rawMessage";
  }

}
