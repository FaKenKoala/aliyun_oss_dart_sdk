import 'package:aliyun_oss_dart_sdk/src/common/http_method.dart';

class GeneratePresignedUrlRequest {
  /// The HTTP method (GET, PUT, DELETE, HEAD) to be used in this request and when the pre-signed URL is used
  late HttpMethod _method;

  /// The name of the bucket involved in this request
  String bucketName;

  /// The key of the object involved in this request
  String key;

  /// process
  String? process;

  /// An optional expiration date at which point the generated pre-signed URL
  /// will no inter be accepted by OSS. If not specified, a default
  /// value will be supplied.
  int expiration;

  /// Content-Type to url sign
  String? contentType;

  /// Content-MD5
  String? contentMD5;

  final Map<String, String> _queryParam = <String, String>{};

  GeneratePresignedUrlRequest(this.bucketName, this.key,
      [this.expiration = 60 * 60, HttpMethod method = HttpMethod.get]) {
    this.method = method;
  }

  HttpMethod get method {
    return _method;
  }

  /// Sets Http method.
  ///
  /// @param method HTTP method.
  set method(HttpMethod method) {
    if (method != HttpMethod.get && method != HttpMethod.put) {
      throw ArgumentError("Only GET or PUT is supported!");
    }

    this.method = method;
  }

  /// Gets the query parameters.
  ///
  /// @return Query parameters.
  Map<String, String> get queryParameter {
    return _queryParam;
  }

  /// Sets the query parameters.
  ///
  /// @param queryParam Query parameters.
  void setQueryParameter(Map<String, String> queryParam) {
    _queryParam
      ..clear()
      ..addAll(queryParam);
  }

  /// @param key
  /// @param value
  void addQueryParameter(String key, String value) {
    _queryParam[key] = value;
  }
}
