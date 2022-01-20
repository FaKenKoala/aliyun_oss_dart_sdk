/// Miscellaneous constants used for oss client service.
class OSSConstants {
  static final String DEFAULT_OSS_ENDPOINT = "http://oss.aliyuncs.com";

  static final String DEFAULT_CHARSET_NAME = "utf-8";
  static final String DEFAULT_XML_ENCODING = "utf-8";

  static final String DEFAULT_OBJECT_CONTENT_TYPE = "application/octet-stream";

  static final int KB = 1024;
  static final int DEFAULT_BUFFER_SIZE = 8 * KB;
  static final int DEFAULT_STREAM_BUFFER_SIZE = 512 * KB;

  static final int DEFAULT_FILE_SIZE_LIMIT = 5 * 1024 * 1024 * 1024;

  static final String RESOURCE_NAME_COMMON = "common";
  static final String RESOURCE_NAME_OSS = "oss";

  static final int OBJECT_NAME_MAX_LENGTH = 1024;

  static final String LOGGER_PACKAGE_NAME = "com.aliyun.oss";

  static final String PROTOCOL_HTTP = "http://";
  static final String PROTOCOL_HTTPS = "https://";
  static final String PROTOCOL_RTMP = "rtmp://";

  // Represents a null OSS version ID
  static final String NULL_VERSION_ID = "null";

  // URL encoding for OSS object keys
  static final String URL_ENCODING = "url";
}
