import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/client_error_code.dart';
import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/model/oss_error_result.dart';
import 'package:aliyun_oss_dart_sdk/src/oss_error_code.dart';
import 'package:aliyun_oss_dart_sdk/src/oss_exception.dart';

/// A simple factory used for creating instances of <code>ClientException</code>
/// and <code>OSSException</code>.
class ExceptionFactory {
  static ClientException createNetworkException(IOException ex) {
    String requestId = "Unknown";
    String errorCode = ClientErrorCode.unknown;

    if (ex is SocketTimeoutException) {
      errorCode = ClientErrorCode.socketTimeout;
    } else if (ex is SocketException) {
      errorCode = ClientErrorCode.socketException;
    } else if (ex is ConnectTimeoutException) {
      errorCode = ClientErrorCode.connectionTimeout;
    } else if (ex is UnknownHostException) {
      errorCode = ClientErrorCode.unknownHost;
    } else if (ex is HttpHostConnectException) {
      errorCode = ClientErrorCode.connectionRefused;
    } else if (ex is NoHttpResponseException) {
      errorCode = ClientErrorCode.connectionTimeout;
    } else if (ex is SSLException) {
      errorCode = ClientErrorCode.sslException;
    } else if (ex is ClientProtocolException) {
      Exception cause = ex.getCause();
      if (cause is NonRepeatableRequestException) {
        errorCode = ClientErrorCode.nonrepeatableRequest;
        return ClientException(cause.getMessage(), errorCode, requestId, cause);
      }
    }

    return ClientException(ex.getMessage(), errorCode, requestId, ex);
  }

  static OSSException createInvalidResponseExceptionWithCause(
      String? requestId, Exception? cause,
      [String? rawResponseError]) {
    return createInvalidResponseException(
        requestId,
        COMMON_RESOURCE_MANAGER.getFormattedString(
            "FailedToParseResponse", cause.getMessage()),
        rawResponseError);
  }

  static OSSException createInvalidResponseException(
      String requestId, String message,
      [String? rawResponseError]) {
    return createOSSException(
        requestId, OSSErrorCode.invalidResponse, message, rawResponseError);
  }

  static OSSException createOSSExceptionWithResult(OSSErrorResult errorResult,
      [String? rawResponseError]) {
    return OSSException(
        errorResult.message,
        errorResult.code,
        errorResult.requestId,
        errorResult.hostId,
        errorResult.header,
        errorResult.resourceType,
        errorResult.method,
        rawResponseError);
  }

  static OSSException createOSSException(
      String requestId, String errorCode, String message,
      [String? rawResponseError]) {
    return OSSException(message, errorCode, requestId, null, null, null, null,
        rawResponseError);
  }

  static OSSException createUnknownOSSException(
      String requestId, int statusCode) {
    String message = "No body in response, http status code $statusCode";
    return OSSException(
        message, ClientErrorCode.unknown, requestId, null, null, null, null);
  }
}
