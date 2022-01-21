import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/common/comm/response_handler.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/response_message.dart';
import 'package:aliyun_oss_dart_sdk/src/common/parser/response_parse_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/oss_error_code.dart';

/// Used to handle error response from oss, when HTTP status code is not 2xx,
/// then throws <code>OSSException</code> with detailed error information(such as
/// request id, error code).
 class OSSErrorResponseHandler implements ResponseHandler {

    @override
     void handle(ResponseMessage response) {

        if (response.isSuccessful()) {
            return;
        }

        String? requestId = response.getRequestId();
        int statusCode = response.statusCode;
        if (response.content == null) {
            /**
             * When HTTP response body is null, handle status code 404 Not
             * Found, 304 Not Modified, 412 Precondition Failed especially.
             */
            if (statusCode == HttpStatus.notFound) {
                throw ExceptionFactory.createOSSException(requestId, OSSErrorCode.noSuchKey, "Not Found");
            } else if (statusCode == HttpStatus.notModified) {
                throw ExceptionFactory.createOSSException(requestId, OSSErrorCode.notModified, "Not Modified");
            } else if (statusCode == HttpStatus.preconditionFailed) {
                throw ExceptionFactory.createOSSException(requestId, OSSErrorCode.preconditionFailed,
                        "Precondition Failed");
            } else if (statusCode == HttpStatus.forbidden) {
                throw ExceptionFactory.createOSSException(requestId, OSSErrorCode.accessForbidden, "AccessForbidden");
            } else {
                throw ExceptionFactory.createUnknownOSSException(requestId, statusCode);
            }
        }

        JAXBResponseParser parser = JAXBResponseParser(OSSErrorResult.class);
        try {
            OSSErrorResult errorResult = (OSSErrorResult) parser.parse(response);
            throw ExceptionFactory.createOSSException(errorResult, response.errorResponseAsString);
        } on ResponseParseException catch ( e) {
            throw ExceptionFactory.createInvalidResponseException(requestId, response.errorResponseAsString, e);
        } finally {
            safeCloseResponse(response);
        }
    }

}
