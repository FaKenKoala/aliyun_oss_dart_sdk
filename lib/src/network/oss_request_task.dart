import 'dart:convert';
import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/common/lib_common.dart';
import 'package:aliyun_oss_dart_sdk/src/exception/lib_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/lib_internal.dart';
import 'package:aliyun_oss_dart_sdk/src/service_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/response_parsers.dart'
    as ResponseParsers;
import 'package:http/http.dart';

import 'package:aliyun_oss_dart_sdk/src/model/lib_model.dart';
import 'lib_network.dart';

class OSSRequestTask<T extends OSSResult> implements Callable<T> {
  ResponseParser<T> responseParser;

  RequestMessage message;

  ExecutionContext context;

  late OkHttpClient client;

  late OSSRetryHandler retryHandler;

  int currentRetryCount = 0;

  OSSRequestTask(
      this.message, this.responseParser, this.context, int maxRetry) {
    client = context.getClient();
    retryHandler = OSSRetryHandler(maxRetry);
  }

  @override
  T call() {
    Request? request;
    ResponseMessage? responseMessage;
    Exception? exception;
    Call call = null;

    try {
      if (context.getApplicationContext() != null) {
        OSSLog.logInfo(
            OSSUtils.buildBaseLogInfo(context.getApplicationContext()));
      }

      OSSLog.logDebug("[call] - ");

      OSSRequest ossRequest = context.request;

      // validate request
      OSSUtils.ensureRequestValid(ossRequest, message);
      // signing
      OSSUtils.signRequest(message);

      if (context.cancellationHandler.isCancelled) {
        throw InterruptedException("This task is cancelled!");
      }

      Request.Builder requestBuilder = Request.Builder();

      // build request url
      String url;
      //区分是否按Endpoint进行URL初始化
      if (ossRequest is ListBucketsRequest) {
        url = message.buildOSSServiceURL();
      } else {
        url = message.buildCanonicalURL();
      }
      requestBuilder = requestBuilder.url(url);

      // set request headers
      message.headers.forEach((key, value) {
        requestBuilder = requestBuilder.addHeader(key, value);
      });

      String? contentType = message.headers[HttpHeaders.contentType];
      OSSLog.logDebug("request method = ${message.method}");
      // set request body
      switch (message.method) {
        case HttpMethod.post:
        case HttpMethod.put:
          OSSUtils.assertTrue(
              contentType != null, "Content type can't be null when upload!");
          InputStream? inputStream;
          String? stringBody;
          int length = 0;
          if (message.uploadData != null) {
            inputStream = ByteArrayInputStream(message.uploadData!);
            length = message.uploadData!.length;
          } else if (message.uploadFilePath != null) {
            File file = File(message.uploadFilePath!);
            inputStream = FileInputStream(file);
            length = file.lengthSync();
            if (length <= 0) {
              throw OSSClientException("the length of file is 0!");
            }
          } else if (message.uploadUri != null) {
            inputStream = context
                .getApplicationContext()
                .getContentResolver()
                .openInputStream(message.uploadUri);
            ParcelFileDescriptor? parcelFileDescriptor;
            try {
              parcelFileDescriptor = context
                  .getApplicationContext()
                  .getContentResolver()
                  .openFileDescriptor(message.uploadUri, "r");
              length = parcelFileDescriptor.getStatSize();
            } finally {
              if (parcelFileDescriptor != null) {
                parcelFileDescriptor.close();
              }
            }
          } else if (message.content != null) {
            inputStream = message.content;
            length = message.contentLength;
          } else {
            stringBody = message.stringBody;
          }

          if (inputStream != null) {
            if (message.checkCRC64) {
              inputStream = CheckedInputStream(inputStream, OSSCRC64());
            }
            message.content = inputStream;
            message.contentLength = (length);
            requestBuilder = requestBuilder.method(
                message.method.toString(),
                NetworkProgressHelper.addProgressRequestBody(
                    inputStream, length, contentType!, context));
          } else if (stringBody != null) {
            requestBuilder = requestBuilder.method(
                message.method.toString(),
                RequestBody.create(
                    MediaType.parse(contentType), utf8.encode(stringBody)));
          } else {
            requestBuilder = requestBuilder.method(
                message.method.toString(), RequestBody.create(null, []));
          }
          break;
        case HttpMethod.get:
          requestBuilder = requestBuilder.get();
          break;
        case HttpMethod.head:
          requestBuilder = requestBuilder.head();
          break;
        case HttpMethod.delete:
          requestBuilder = requestBuilder.delete();
          break;
        default:
          break;
      }

      request = requestBuilder.build();

      if (ossRequest is GetObjectRequest) {
        client =
            NetworkProgressHelper.addProgressResponseListener(client, context);
        OSSLog.logDebug("getObject");
      }

      call = client.newCall(request);

      context.cancellationHandler.call = (call);

      // send sync request
      Response response = call.execute();

      if (OSSLog.isEnableLog()) {
        // response log
        // Map<String, List<String>> headerMap = response.headers.toMultimap();
        Map<String, String> headerMap = response.headers; //.toMultimap();
        StringBuffer printRsp = StringBuffer();
        printRsp.write("response:---------------------\n");
        printRsp.write(
            "response code: ${response.statusCode} for url: ${request?.url}\n");
//                printRsp.write("response body: " + response.body().string() + "\n");
        headerMap.forEach((key, value) {
          printRsp
            ..write("responseHeader [$key]: ")
            ..write("${value}\n");
        });
        OSSLog.logDebug(printRsp.toString());
      }

      // create response message
      responseMessage = buildResponseMessage(message, response);
    } catch (e) {
      OSSLog.logError("Encounter local execpiton: " + e.toString());
      if (OSSLog.isEnableLog()) {
        print(e);
      }
      exception = OSSClientException(e);
    }

    if (exception == null &&
        (responseMessage!.statusCode ==
                HttpStatus.nonAuthoritativeInformation ||
            responseMessage.statusCode >= HttpStatus.multipleChoices)) {
      exception = ResponseParsers.parseResponseErrorXML(responseMessage,
          request?.method.equalsIgnoreCase(HttpMethod.head.name) ?? false);
    } else if (exception == null) {
      try {
        T result = responseParser.parse(responseMessage!);

        context.completedCallback?.onSuccess(context.request, result);
        return result;
      } on OSSIOException catch (e) {
        exception = OSSClientException(e);
      }
    }

    // reconstruct exception caused by manually cancelling
    if ((call != null && call.isCanceled()) ||
        context.cancellationHandler.isCancelled) {
      exception = OSSClientException("Task is cancelled! $exception", true);
    }

    OSSRetryType retryType =
        retryHandler.shouldRetry(exception, currentRetryCount);
    OSSLog.logError("[run] - retry, retry type: $retryType");
    if (retryType == OSSRetryType.OSSRetryTypeShouldRetry) {
      currentRetryCount++;
      context.retryCallback?.onRetryCallback();

      try {
        Thread.sleep(retryHandler.timeInterval(currentRetryCount, retryType));
      } on InterruptedException catch (e) {
        Thread.currentThread().interrupt();
      }

      return call();
    } else if (retryType ==
        OSSRetryType.OSSRetryTypeShouldFixedTimeSkewedAndRetry) {
      // Updates the DATE header value and try again
      if (responseMessage != null) {
        String? responseDateString = responseMessage.headers[HttpHeaders.date];
        try {
          // update the server time after every response
          int serverTime = DateUtil.parseRfc822Date(responseDateString!)
              .millisecondsSinceEpoch;
          DateUtil.setCurrentServerTime(serverTime);
          message.headers[HttpHeaders.date] = responseDateString;
        } catch (ignore) {
          // Fail to parse the time, ignore it
          OSSLog.logError(
              "[error] - synchronize time, reponseDate:$responseDateString");
        }
      }

      currentRetryCount++;
      context.retryCallback?.onRetryCallback();
      return call();
    } else {
      if (exception is OSSClientException) {
        context.completedCallback?.onFailure(context.request, exception, null);
      } else {
        context.completedCallback?.onFailure(
            context.request, null, exception as OSSServiceException);
      }
      throw exception;
    }
  }

  ResponseMessage buildResponseMessage(
      RequestMessage request, Response response) {
    ResponseMessage responseMessage = ResponseMessage();
    responseMessage.request = request;
    responseMessage.response = response;
    Map<String, String> headers = <String, String>{};
    headers.addAll(response.headers);

    responseMessage.headers = headers;
    responseMessage.statusCode = response.statusCode;
    responseMessage.contentLength = response.contentLength ?? -1;
    responseMessage.content = response.body;
    return responseMessage;
  }
}
