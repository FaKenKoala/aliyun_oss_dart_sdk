import '../http_method.dart';
import 'response_header_overrides.dart';

/// This class wraps all the information needed to generate a presigned URl. And
/// it's not the real "request" class.
class GeneratePresignedUrlRequest {
  /// The HTTP method (GET, PUT, DELETE, HEAD) to be used in this request and
  /// when the pre-signed URL is used
  HttpMethod? _method;

  /// The name of the bucket involved in this request
  String bucketName;

  /// The key of the object involved in this request
  String key;

  /// Content-Type to url sign
  String? contentType;

  /// Content-MD5
  String? contentMD5;

  /// process
  String? process;

  /// An optional expiration date at which point the generated pre-signed URL
  /// will no longer be accepted by OSS. If not specified, a default value will
  /// be supplied.
  DateTime? expiration;

  // The response headers to override.
  ResponseHeaderOverrides responseHeaders = ResponseHeaderOverrides();

  // User's customized metadata, which are the http headers start with the
  // x-oos-meta-.
  Map<String, String> userMetadata = <String, String>{};

  Map<String, String> queryParam = <String, String>{};

  Map<String, String> headers = <String, String>{};

  Set<String> additionalHeaderNames = <String>{};

  // Traffic limit speed, its uint is bit/s
  int trafficLimit = 0;

  GeneratePresignedUrlRequest(this.bucketName, this.key,
      [this._method = HttpMethod.get]);

  HttpMethod? getMethod() {
    return _method;
  }

  void setMethod(HttpMethod method) {
    if (method != HttpMethod.get && method != HttpMethod.put) {
      throw ArgumentError("Only GET or PUT is supported!");
    }

    _method = method;
  }

  void addUserMetadata(String key, String value) {
    userMetadata[key] = value;
  }

  void addQueryParameter(String key, String value) {
    queryParam[key] = value;
  }

  void addHeader(String key, String value) {
    headers[key] = value;
  }

  void addAdditionalHeaderName(String name) {
    additionalHeaderNames.add(name);
  }
}
