/// The class wraps the HTTP Get response headers to override. For Response
/// headers, please refer to
/// https://help.aliyun.com/document_detail/31980.html?spm=5176.doc31980.6.870.
/// zfxavo Basically it tells the OSS to return the specified headers in the
/// response.
class ResponseHeaderOverrides {
  String? contentType;
  String? contentLangauge;
  String? expires;
  String? cacheControl;
  String? contentDisposition;
  String? contentEncoding;

  static final String RESPONSE_HEADER_CONTENT_TYPE = "response-content-type";
  static final String RESPONSE_HEADER_CONTENT_LANGUAGE =
      "response-content-language";
  static final String RESPONSE_HEADER_EXPIRES = "response-expires";
  static final String RESPONSE_HEADER_CACHE_CONTROL = "response-cache-control";
  static final String RESPONSE_HEADER_CONTENT_DISPOSITION =
      "response-content-disposition";
  static final String RESPONSE_HEADER_CONTENT_ENCODING =
      "response-content-encoding";
}
