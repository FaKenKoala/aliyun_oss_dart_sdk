class OSSConstants {
  static final String sdkVersion = "2.9.11";
  static final String defaultToOSSEndpoint =
      "http://oss-cn-hangzhou.aliyuncs.com";

  static final String defaultCharsetName = "utf-8";
  static const String defaultXml = "utf-8";

  static final String defaultObjectContentType = "application/octet-stream";

  static final int KB = 1024;
  static final int defaultBufferSize = 8 * KB;
  static final int defaultStreamBufferSize = 128 * KB;

  static final int defaultRetryCount = 2;
  static final int defaultBaseThreadPoolSize = 5;

  static final int defaultFileSizeLimit = 5 * 1024 * 1024 * 1024;

  static final int minPartSizeLimit = 100 * KB;

  static final String resourceNameCommon = "common";
  static final String resourceNameOss = "oss";

  static final int objectNameMaxLength = 1024;

  static final List<String> defaultCnameExcludeList = [
    "aliyuncs.com",
    "aliyun-inc.com",
    "aliyun.com",
  ];

  static final List<String> ossOrignHost = [
    "aliyuncs.com",
    "aliyun-inc.com",
    "aliyun.com",
  ];
}
