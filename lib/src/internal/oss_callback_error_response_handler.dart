import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/common/comm/response_handler.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/response_message.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/exception_factory.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/model/oss_error_result.dart';

class OSSCallbackErrorResponseHandler implements ResponseHandler {
  @override
  void handle(ResponseMessage response) {
    if (response.statusCode == HttpStatus.nonAuthoritativeInformation) {
      try {
        OSSErrorResult errorResult =
            OSSErrorResult.readXml(response.content?.data);
        throw ExceptionFactory.createOSSExceptionWithResult(
            errorResult, response.errorResponseAsString);
      } catch (e) {
        throw ExceptionFactory.createInvalidResponseException(
            response.getRequestId(), response.errorResponseAsString, e);
      } finally {
        safeCloseResponse(response);
      }
    }
  }
}
