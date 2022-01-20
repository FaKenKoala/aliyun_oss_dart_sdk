import 'package:aliyun_oss_dart_sdk/src/common/auth/credentials.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/request_signer.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/oss_constants.dart';

import 'request_handler.dart';
import 'response_handler.dart';
import 'retry_strategy.dart';

class ExecutionContext {
  /* Request signer */
  RequestSigner? signer;

  /* The request handlers that handle request content in as a pipeline. */
  final List<RequestHandler> _requestHandlers = [];

  /* The response handlers that handle response message in as a pipeline. */
  final List<ResponseHandler> _responseHandlers = [];

  /* The signer handlers that handle sign request in as a pipeline. */
  final List<RequestSigner> _signerHandlers = [];

  String charset = OSSConstants.DEFAULT_CHARSET_NAME;

  /* Retry strategy when HTTP request fails. */
  RetryStrategy? retryStrategy;

  Credentials? credentials;

  List<ResponseHandler> getResponseHandlers() {
    return _responseHandlers;
  }

  void addResponseHandler(ResponseHandler handler) {
    _responseHandlers.add(handler);
  }

  void insertResponseHandler(int position, ResponseHandler handler) {
    _responseHandlers.insert(position, handler);
  }

  void removeResponseHandler(ResponseHandler handler) {
    _responseHandlers.remove(handler);
  }

  List<RequestHandler> getResquestHandlers() {
    return _requestHandlers;
  }

  void addRequestHandler(RequestHandler handler) {
    _requestHandlers.add(handler);
  }

  void insertRequestHandler(int position, RequestHandler handler) {
    _requestHandlers.insert(position, handler);
  }

  void removeRequestHandler(RequestHandler handler) {
    _requestHandlers.remove(handler);
  }

  List<RequestSigner> getSignerHandlers() {
    return _signerHandlers;
  }

  void addSignerHandler(RequestSigner handler) {
    _signerHandlers.add(handler);
  }

  void insertSignerHandler(int position, RequestSigner handler) {
    _signerHandlers.insert(position, handler);
  }

  void removeSignerHandler(RequestSigner handler) {
    _signerHandlers.remove(handler);
  }
}
