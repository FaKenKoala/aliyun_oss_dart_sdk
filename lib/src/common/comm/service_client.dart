import 'package:aliyun_oss_dart_sdk/src/client_configuration.dart';
import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/request_signer.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_headers.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/http_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/log_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';
import 'package:aliyun_oss_dart_sdk/src/http_method.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/oss_constants.dart';
import 'package:aliyun_oss_dart_sdk/src/service_exception.dart';

import 'execution_context.dart';
import 'http_message.dart';
import 'request_handler.dart';
import 'request_message.dart';
import 'response_handler.dart';
import 'response_message.dart';
import 'retry_strategy.dart';

abstract class ServiceClient {
  ClientConfiguration config;

  ServiceClient(this.config);

  /// Send HTTP request with specified context to OSS and wait for HTTP
  /// response.
  ResponseMessage sendRequest(
      RequestMessage request, ExecutionContext context) {
    try {
      return sendRequestImpl(request, context);
    } finally {
      // Close the request stream as well after the request is completed.
      try {
        request.close();
      } catch (ex) {
        LogUtils.logException(
            "Unexpected io exception when trying to close http request: ", ex);
        throw ClientException(
            "Unexpected io exception when trying to close http request: ", ex);
      }
    }
  }

  ResponseMessage sendRequestImpl(
      RequestMessage request, ExecutionContext context) {
    RetryStrategy retryStrategy =
        context.retryStrategy ?? getDefaultRetryStrategy();

    // Sign the request if a signer provided.
    if (context.signer != null && !request.useUrlSignature) {
      context.signer!.sign(request);
    }

    for (RequestSigner signer in context.getSignerHandlers()) {
      signer.sign(request);
    }

    InputStream? requestContent = request.content;
    if (requestContent != null && requestContent.markSupported()) {
      requestContent.mark(OSSConstants.DEFAULT_STREAM_BUFFER_SIZE);
    }

    int retries = 0;
    ResponseMessage? response;

    while (true) {
      try {
        if (retries > 0) {
          pause(retries, retryStrategy);
          if (requestContent != null && requestContent.markSupported()) {
            try {
              requestContent.reset();
            } catch (ex) {
              LogUtils.logException(
                  "Failed to reset the request input stream: ", ex);
              throw ClientException(
                  "Failed to reset the request input stream: $ex");
            }
          }
        }

        /*
                 * The key four steps to send HTTP requests and receive HTTP
                 * responses.
                 */

        // Step 1. Preprocess HTTP request.
        handleRequest(request, context.getResquestHandlers());

        // Step 2. Build HTTP request with specified request parameters
        // and context.
        Request httpRequest = buildRequest(request, context);

        // Step 3. Send HTTP request to OSS.
        String poolStatsInfo = config.logConnectionPoolStats
            ? "Connection pool stats " + getConnectionPoolStats()
            : "";
        int startTime = DateTime.now().millisecondsSinceEpoch;
        response = sendRequestCore(httpRequest, context);
        int duration = DateTime.now().millisecondsSinceEpoch - startTime;
        if (duration > config.slowRequestsThreshold) {
          LogUtils.getLog().warn(
              formatSlowRequestLog(request, response, duration) +
                  poolStatsInfo);
        }

        // Step 4. Preprocess HTTP response.
        handleResponse(response, context.getResponseHandlers());

        return response;
      } on ServiceException catch (sex) {
        LogUtils.logException("[Server]Unable to execute HTTP request: ", sex,
            request.originalRequest.logEnabled);

        // Notice that the response should not be closed in the
        // finally block because if the request is successful,
        // the response should be returned to the callers.
        closeResponseSilently(response);

        if (!shouldRetry(sex, request, response, retries, retryStrategy)) {
          rethrow;
        }
      } on ClientException catch (cex) {
        LogUtils.logException("[Client]Unable to execute HTTP request: ", cex,
            request.originalRequest.logEnabled);

        closeResponseSilently(response);

        if (!shouldRetry(cex, request, response, retries, retryStrategy)) {
          rethrow;
        }
      } catch (ex) {
        LogUtils.logException("[Unknown]Unable to execute HTTP request: ", ex,
            request.originalRequest.logEnabled);

        closeResponseSilently(response);

        throw ClientException(
            COMMON_RESOURCE_MANAGER.getFormattedString(
                "ConnectionError", ex.getMessage()),
            ex);
      } finally {
        retries++;
      }
    }
  }

  /// Implements the core logic to send requests to Aliyun OSS services.
  ResponseMessage sendRequestCore(Request request, ExecutionContext context);

  Request buildRequest(
      RequestMessage requestMessage, ExecutionContext context) {
    Request request = Request();
    request.method = requestMessage.method;
    request.useChunkEncoding = requestMessage.useChunkEncoding;

    if (requestMessage.useUrlSignature) {
      request.uri = requestMessage.absoluteUrl?.toString();
      request.useUrlSignature = true;

      request
        ..content = requestMessage.content
        ..contentLength = requestMessage.contentLength
        ..headers = requestMessage.headers;

      return request;
    }

    request.headers = requestMessage.headers;
    // The header must be converted after the request is signed,
    // otherwise the signature will be incorrect.
    if (request.headers != null) {
      HttpUtil.convertHeaderCharsetToIso88591(request.headers);
    }

    final String delimiter = "/";
    String uri = requestMessage.endpoint.toString();
    if (!uri.endsWith(delimiter) &&
        (requestMessage.resourcePath == null ||
            !requestMessage.resourcePath!.startsWith(delimiter))) {
      uri += delimiter;
    }

    if (requestMessage.resourcePath != null) {
      uri += requestMessage.resourcePath!;
    }

    String? paramString =
        HttpUtil.paramToQueryString(requestMessage.parameters, context.charset);

    /*
         * For all non-POST requests, and any POST requests that already have a
         * payload, we put the encoded params directly in the URI, otherwise,
         * we'll put them in the POST request's payload.
         */
    bool requestHasNoPayload = requestMessage.content != null;
    bool requestIsPost = requestMessage.method == HttpMethod.POST;
    bool putParamsInUri = !requestIsPost || requestHasNoPayload;
    if (paramString != null && putParamsInUri) {
      uri += "?" + paramString;
    }

    request.uri = uri;

    if (requestIsPost &&
        requestMessage.content == null &&
        paramString != null) {
      // Put the param string to the request body if POSTing and
      // no content.
      try {
        List<int> buf = paramString.getBytes(context.charset);
        ByteArrayInputStream content = ByteArrayInputStream(buf);
        request.content = content;
        request.contentLength = buf.length;
      } catch (e) {
        throw RuntimeException(COMMON_RESOURCE_MANAGER.getFormattedString(
            "EncodingFailed", e.getMessage()));
      }
    } else {
      request.content = requestMessage.content;
      request.contentLength = requestMessage.contentLength;
    }

    return request;
  }

  void handleResponse(
      ResponseMessage response, List<ResponseHandler> responseHandlers) {
    for (ResponseHandler h in responseHandlers) {
      h.handle(response);
    }
  }

  void handleRequest(
      RequestMessage message, List<RequestHandler> resquestHandlers) {
    for (RequestHandler h in resquestHandlers) {
      h.handle(message);
    }
  }

  void pause(int retries, RetryStrategy retryStrategy) {
    int delay = retryStrategy.getPauseDelay(retries);

    LogUtils.getLog().debug(
        "An retriable error request will be retried after $delay(ms) with attempt times: $retries");

    try {
      Thread.sleep(delay);
    } catch (e) {
      throw ClientException(e);
    }
  }

  bool shouldRetry(Exception exception, RequestMessage request,
      ResponseMessage? response, int retries, RetryStrategy retryStrategy) {
    if (retries >= config.maxErrorRetry) {
      return false;
    }

    if (!request.isRepeatable()) {
      return false;
    }

    if (retryStrategy.shouldRetry(exception, request, response, retries)) {
      LogUtils.getLog()
          .debug("Retrying on ${exception.runtimeType}: $exception");
      return true;
    }
    return false;
  }

  void closeResponseSilently(ResponseMessage? response) {
    if (response != null) {
      try {
        response.close();
      } catch (ioe) {
        /* silently close the response. */
      }
    }
  }

  String formatSlowRequestLog(
      RequestMessage request, ResponseMessage response, int useTimesMs) {
    return "Request cost ${useTimesMs / 1000} seconds, endpoint ${request.endpoint}, resourcePath ${request.resourcePath}, method ${request.method}, Date '${request.headers[HttpHeaders.DATE]}', statusCode ${response.statusCode}, requestId ${response.getRequestId()}.";
  }

  RetryStrategy getDefaultRetryStrategy();

  void shutdown();

  String getConnectionPoolStats() {
    return "";
  }
}

/// Wrapper class based on {@link HttpMessage} that represents HTTP request
/// message to OSS.
class Request extends HttpMessage {
  String? uri;
  HttpMethod? method;
  bool useUrlSignature = false;
  bool useChunkEncoding = false;
}
