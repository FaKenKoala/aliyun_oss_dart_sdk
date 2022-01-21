import 'package:aliyun_oss_dart_sdk/src/common/auth/credentials.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/credentials_provider.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/request_signer.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/execution_context.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/request_checksum_handler.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/request_handler.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/request_message.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/request_progress_handler.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/response_handler.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/response_message.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/response_progress_handler.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/retry_strategy.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/service_client.dart';
import 'package:aliyun_oss_dart_sdk/src/common/comm/sign_version.dart';
import 'package:aliyun_oss_dart_sdk/src/common/parser/response_parse_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/common/parser/response_parser.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/exception_factory.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/log_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/http_method.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/oss_headers.dart';
import 'package:aliyun_oss_dart_sdk/src/model/web_service_request.dart';
import 'package:aliyun_oss_dart_sdk/src/oss_exception.dart';

import 'oss_request_signer.dart';

/// Abstract base class that provides some common functionalities for OSS
/// operations (such as bucket/object/multipart/cors operations).
abstract class OSSOperation {
  Uri? _endpoint;
  CredentialsProvider credsProvider;
  ServiceClient client;

  static OSSErrorResponseHandler errorResponseHandler =
      OSSErrorResponseHandler();
  static EmptyResponseParser emptyResponseParser = EmptyResponseParser();
  static RequestIdResponseParser requestIdResponseParser =
      RequestIdResponseParser();
  static RetryStrategy noRetryStrategy = NoRetryStrategy();

  OSSOperation(this.client, this.credsProvider);

  Uri? getEndpoint([WebServiceRequest? request]) {
    if (request == null || request.endpoint == null) {
      return _endpoint;
    }

    String defaultProto =
        client.getClientConfiguration().getProtocol().toString();
    Uri ret = OSSUtils.toEndpointURI(reqEndpoint, defaultProto);
    OSSUtils.ensureEndpointValid(ret.host);
    return ret;
  }

  void setEndpoint(Uri endpoint) {
    _endpoint = endpoint;
  }

  ServiceClient getInnerClient() {
    return client;
  }

  ResponseMessage? send(RequestMessage request, ExecutionContext context,
      [bool keepResponseOpen = false]) {
    ResponseMessage? response;
    try {
      response = client.sendRequest(request, context);
      return response;
    } catch (e) {
      assert(e is OSSException);
      rethrow;
    } finally {
      if (response != null && !keepResponseOpen) {
        safeCloseResponse(response);
      }
    }
  }

  T doOperation<T>(RequestMessage request, ResponseParser<T> parser,
      String bucketName, String key,
      [bool keepResponseOpen = false,
      List<RequestHandler>? requestHandlers,
      List<ResponseHandler>? reponseHandlers]) {
    final WebServiceRequest originalRequest = request.originalRequest;
    request.headers.addAll(client.getClientConfiguration().getDefaultHeaders());
    request.headers.addAll(originalRequest.headers);
    request.parameters.addAll(originalRequest.parameters);

    ExecutionContext context =
        createDefaultContext(request.method, bucketName, key, originalRequest);

    if (context.credentials.useSecurityToken() &&
        !request.useUrlSignature) {
      request.addHeader(OSSHeaders.ossSecurityToken,
          context.credentials.getSecurityToken());
    }

    context.addRequestHandler(RequestProgressHanlder());
    if (requestHandlers != null) {
      for (RequestHandler handler in requestHandlers) {
        context.addRequestHandler(handler);
      }
    }
    if (client.getClientConfiguration().isCrcCheckEnabled()) {
      context.addRequestHandler(RequestChecksumHanlder());
    }

    context.addResponseHandler(ResponseProgressHandler(originalRequest));
    if (reponseHandlers != null) {
      for (ResponseHandler handler in reponseHandlers) {
        context.addResponseHandler(handler);
      }
    }
    if (client.getClientConfiguration().isCrcCheckEnabled()) {
      context.addResponseHandler(ResponseChecksumHandler());
    }

    List<RequestSigner>? signerHandlers =
        client.getClientConfiguration().getSignerHandlers();
    if (signerHandlers != null) {
      for (RequestSigner signer in signerHandlers) {
        context.addSignerHandler(signer);
      }
    }

    ResponseMessage response = send(request, context, keepResponseOpen);

    try {
      return parser.parse(response);
    } on ResponseParseException catch (rpe) {
      OSSException oe = ExceptionFactory.createInvalidResponseExceptionWithCause(
          response.getRequestId(), rpe, rpe.message);
      LogUtils.logException("Unable to parse response error: ", rpe);
      throw oe;
    }
  }

  static RequestSigner createSigner(HttpMethod method, String bucketName,
      String key, Credentials creds, SignVersion signatureVersion) {
    String resourcePath = "/" +
        ((bucketName != null) ? bucketName + "/" : "") +
        ((key != null ? key : ""));

    return OSSRequestSigner(
        method.toString(), resourcePath, creds, signatureVersion);
  }

  ExecutionContext createDefaultContext(HttpMethod method, String bucketName,
      [String? key, WebServiceRequest? originalRequest]) {
    ExecutionContext context = ExecutionContext();
    Credentials credentials = credsProvider.getCredentials();
    assertParameterNotNull(credentials, "credentials");
    context.setCharset(DEFAULT_CHARSET_NAME);
    context.setSigner(createSigner(method, bucketName, key, credentials,
        client.getClientConfiguration().getSignatureVersion()));
    context.addResponseHandler(errorResponseHandler);
    if (method == HttpMethod.post && !isRetryablePostRequest(originalRequest)) {
      context.setRetryStrategy(noRetryStrategy);
    }

    if (client.getClientConfiguration().getRetryStrategy() != null) {
      context
          .setRetryStrategy(client.getClientConfiguration().getRetryStrategy());
    }

    context.setCredentials(credentials);
    return context;
  }

  bool isRetryablePostRequest(WebServiceRequest request) {
    return false;
  }
}
