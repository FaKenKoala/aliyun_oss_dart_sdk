import 'package:aliyun_oss_dart_sdk/src/common/comm/http_message.dart';
import 'package:aliyun_oss_dart_sdk/src/http_method.dart';
import 'package:aliyun_oss_dart_sdk/src/model/web_service_request.dart';

class RequestMessage extends HttpMessage {
  /* bucket name */
  String? bucket;

  /* object name */
  String? key;

  /* The resource path being requested */
  String? resourcePath;

  /* The service endpoint to which this request should be sent */
  late Uri endpoint;

  /* The HTTP method to use when sending this request */
  HttpMethod method = HttpMethod.GET;

  /* Use a LinkedHashMap to preserve the insertion order. */
  final Map<String, String> _parameters = <String, String>{};

  /* The absolute url to which the request should be sent */
  Uri? absoluteUrl;

  /* Indicate whether using url signature */
  bool useUrlSignature = false;

  /* Indicate whether using chunked encoding */
  bool useChunkEncoding = false;

  /* The original request provided by user */
  final WebServiceRequest originalRequest;

  RequestMessage(this.bucket, this.key,
      [final WebServiceRequest? originalRequest])
      : originalRequest = originalRequest ?? WebServiceRequest.noop;

  Map<String, String> get parameters => _parameters;
  set parameters(Map<String, String>? parameters) {
    _parameters.clear();
    if (parameters?.isNotEmpty ?? false) {
      _parameters.addAll(parameters!);
    }
  }

  void addParameter(String key, String value) {
    _parameters[key] = value;
  }

  void removeParameter(String key) {
    _parameters.remove(key);
  }

  /// Indicate whether the request should be repeatedly sent.
  bool isRepeatable() {
    return content?.markSupported() ?? false;
  }

  @override
  String toString() {
    return "Endpoint: ${endpoint.host}, ResourcePath: $resourcePath, Headers: $headers";
  }
}
