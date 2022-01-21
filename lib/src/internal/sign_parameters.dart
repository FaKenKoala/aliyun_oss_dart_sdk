import 'package:aliyun_oss_dart_sdk/src/model/response_header_overrides.dart';

import 'request_parameters.dart';

class SignParameters {
  static final String AUTHORIZATION_PREFIX = "OSS ";

  static final String AUTHORIZATION_PREFIX_V2 = "OSS2 ";

  static final String AUTHORIZATION_V2 = "OSS2";

  static final String AUTHORIZATION_ACCESS_KEY_ID = "AccessKeyId";

  static final String AUTHORIZATION_ADDITIONAL_HEADERS = "AdditionalHeaders";

  static final String AUTHORIZATION_SIGNATURE = "Signature";

  static final String NEW_LINE = "\n";

  static final List<String> SIGNED_PARAMTERS = [
    RequestParameters.SUBRESOURCE_ACL,
    RequestParameters.SUBRESOURCE_UPLOADS,
    RequestParameters.SUBRESOURCE_LOCATION,
    RequestParameters.SUBRESOURCE_CORS,
    RequestParameters.SUBRESOURCE_LOGGING,
    RequestParameters.SUBRESOURCE_WEBSITE,
    RequestParameters.SUBRESOURCE_REFERER,
    RequestParameters.SUBRESOURCE_LIFECYCLE,
    RequestParameters.SUBRESOURCE_DELETE,
    RequestParameters.SUBRESOURCE_APPEND,
    RequestParameters.SUBRESOURCE_TAGGING,
    RequestParameters.SUBRESOURCE_OBJECTMETA,
    RequestParameters.UPLOAD_ID,
    RequestParameters.PART_NUMBER,
    RequestParameters.SECURITY_TOKEN,
    RequestParameters.POSITION,
    ResponseHeaderoverrides.RESPONSE_HEADER_CACHE_CONTROL,
    ResponseHeaderoverrides.RESPONSE_HEADER_CONTENT_DISPOSITION,
    ResponseHeaderoverrides.RESPONSE_HEADER_CONTENT_ENCODING,
    ResponseHeaderoverrides.RESPONSE_HEADER_CONTENT_LANGUAGE,
    ResponseHeaderoverrides.RESPONSE_HEADER_CONTENT_TYPE,
    ResponseHeaderoverrides.RESPONSE_HEADER_EXPIRES,
    RequestParameters.SUBRESOURCE_IMG,
    RequestParameters.SUBRESOURCE_STYLE,
    RequestParameters.STYLE_NAME,
    RequestParameters.SUBRESOURCE_REPLICATION,
    RequestParameters.SUBRESOURCE_REPLICATION_PROGRESS,
    RequestParameters.SUBRESOURCE_REPLICATION_LOCATION,
    RequestParameters.SUBRESOURCE_CNAME,
    RequestParameters.SUBRESOURCE_BUCKET_INFO,
    RequestParameters.SUBRESOURCE_COMP,
    RequestParameters.SUBRESOURCE_QOS,
    RequestParameters.SUBRESOURCE_LIVE,
    RequestParameters.SUBRESOURCE_STATUS,
    RequestParameters.SUBRESOURCE_VOD,
    RequestParameters.SUBRESOURCE_START_TIME,
    RequestParameters.SUBRESOURCE_END_TIME,
    RequestParameters.SUBRESOURCE_PROCESS,
    RequestParameters.SUBRESOURCE_PROCESS_CONF,
    RequestParameters.SUBRESOURCE_SYMLINK,
    RequestParameters.SUBRESOURCE_STAT,
    RequestParameters.SUBRESOURCE_UDF,
    RequestParameters.SUBRESOURCE_UDF_NAME,
    RequestParameters.SUBRESOURCE_UDF_IMAGE,
    RequestParameters.SUBRESOURCE_UDF_IMAGE_DESC,
    RequestParameters.SUBRESOURCE_UDF_APPLICATION,
    RequestParameters.SUBRESOURCE_UDF_LOG,
    RequestParameters.SUBRESOURCE_RESTORE,
    RequestParameters.SUBRESOURCE_VRESIONS,
    RequestParameters.SUBRESOURCE_VRESIONING,
    RequestParameters.SUBRESOURCE_VRESION_ID,
    RequestParameters.SUBRESOURCE_ENCRYPTION,
    RequestParameters.SUBRESOURCE_POLICY,
    RequestParameters.SUBRESOURCE_REQUEST_PAYMENT,
    RequestParameters.OSS_TRAFFIC_LIMIT,
    RequestParameters.SUBRESOURCE_QOS_INFO,
    RequestParameters.SUBRESOURCE_ASYNC_FETCH,
    RequestParameters.SEQUENTIAL,
    RequestParameters.OSS_REQUEST_PAYER,
    RequestParameters.VPCIP,
    RequestParameters.VIP,
    RequestParameters.SUBRESOURCE_INVENTORY,
    RequestParameters.SUBRESOURCE_INVENTORY_ID,
    RequestParameters.SUBRESOURCE_CONTINUATION_TOKEN,
    RequestParameters.SUBRESOURCE_WORM,
    RequestParameters.SUBRESOURCE_WORM_ID,
    RequestParameters.SUBRESOURCE_WORM_EXTEND,
    RequestParameters.SUBRESOURCE_CALLBACK,
    RequestParameters.SUBRESOURCE_CALLBACK_VAR,
    RequestParameters.SUBRESOURCE_DIR,
    RequestParameters.SUBRESOURCE_RENAME,
    RequestParameters.SUBRESOURCE_DIR_DELETE,
    RequestParameters.SUBRESOURCE_TRANSFER_ACCELERATION,
  ];
}
