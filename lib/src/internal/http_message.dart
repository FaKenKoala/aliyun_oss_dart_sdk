import 'dart:collection';

abstract class HttpMessage {
  final Map<String, String> _headers = LinkedHashMap<String, String>(
      equals: (p0, p1) => p0.toLowerCase() == p1.toLowerCase());

  InputStream? content;
  int contentLength = 0;
  String? stringBody;

  Map<String, String> get headers => _headers;
  set headers(Map<String, String> headers) {
    headers.clear();
    _headers.addAll(headers);
  }

  void addHeader(String key, String value) {
    _headers[key] = value;
  }

  void close() {
    content?.close();
    content = null;
  }
}

class InputStream {
  close() {}
}
