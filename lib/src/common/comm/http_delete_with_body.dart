class HttpDeleteWithBody extends HttpEntityEnclosingRequestBase {
  static final String METHOD_NAME = "DELETE";

  HttpDeleteWithBody([Uri? uri, String? uriStr]) {
    setURI(uri);
  }

  HttpDeleteWithBody(final String uri) {
    super();
    setURI(URI.create(uri));
  }

  @override
  String getMethod() {
    return METHOD_NAME;
  }
}
