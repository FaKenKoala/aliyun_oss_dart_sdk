package com.alibaba.sdk.android.oss.common;

/**
 * Miscellaneous constants used for oss client service.
 */
 final class OSSConstants {

     static final String SDK_VERSION = "2.9.11";
     static final String DEFAULT_OSS_ENDPOINT = "http://oss-cn-hangzhou.aliyuncs.com";

     static final String DEFAULT_CHARSET_NAME = "utf-8";
     static final String DEFAULT_XML_ENCODING = "utf-8";

     static final String DEFAULT_OBJECT_CONTENT_TYPE = "application/octet-stream";

     static final int KB = 1024;
     static final int DEFAULT_BUFFER_SIZE = 8 * KB;
     static final int DEFAULT_STREAM_BUFFER_SIZE = 128 * KB;

     static final int DEFAULT_RETRY_COUNT = 2;
     static final int DEFAULT_BASE_THREAD_POOL_SIZE = 5;

     static final int DEFAULT_FILE_SIZE_LIMIT = 5 * 1024 * 1024 * 1024L;

     static final int MIN_PART_SIZE_LIMIT = 100 * KB;

     static final String RESOURCE_NAME_COMMON = "common";
     static final String RESOURCE_NAME_OSS = "oss";

     static final int OBJECT_NAME_MAX_LENGTH = 1024;

     static final String[] DEFAULT_CNAME_EXCLUDE_LIST = new String[]{
            "aliyuncs.com",
            "aliyun-inc.com",
            "aliyun.com"
    };

     static final String[] OSS_ORIGN_HOST = new String[]{
            "aliyuncs.com",
            "aliyun-inc.com",
            "aliyun.com"
    };
}
