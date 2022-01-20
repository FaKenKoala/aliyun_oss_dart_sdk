class RequestParameters {
  static final String SUBRESOURCE_ACL = "acl";
  static final String SUBRESOURCE_REFERER = "referer";
  static final String SUBRESOURCE_LOCATION = "location";
  static final String SUBRESOURCE_LOGGING = "logging";
  static final String SUBRESOURCE_WEBSITE = "website";
  static final String SUBRESOURCE_LIFECYCLE = "lifecycle";
  static final String SUBRESOURCE_UPLOADS = "uploads";
  static final String SUBRESOURCE_DELETE = "delete";
  static final String SUBRESOURCE_CORS = "cors";
  static final String SUBRESOURCE_APPEND = "append";
  static final String SUBRESOURCE_TAGGING = "tagging";
  static final String SUBRESOURCE_IMG = "img";
  static final String SUBRESOURCE_STYLE = "style";
  static final String SUBRESOURCE_REPLICATION = "replication";
  static final String SUBRESOURCE_REPLICATION_PROGRESS = "replicationProgress";
  static final String SUBRESOURCE_REPLICATION_LOCATION = "replicationLocation";
  static final String SUBRESOURCE_CNAME = "cname";
  static final String SUBRESOURCE_BUCKET_INFO = "bucketInfo";
  static final String SUBRESOURCE_COMP = "comp";
  static final String SUBRESOURCE_OBJECTMETA = "objectMeta";
  static final String SUBRESOURCE_QOS = "qos";
  static final String SUBRESOURCE_LIVE = "live";
  static final String SUBRESOURCE_STATUS = "status";
  static final String SUBRESOURCE_VOD = "vod";
  static final String SUBRESOURCE_START_TIME = "startTime";
  static final String SUBRESOURCE_END_TIME = "endTime";
  static final String SUBRESOURCE_PROCESS_CONF = "processConfiguration";
  static final String SUBRESOURCE_PROCESS = "x-oss-process";
  static final String SUBRESOURCE_CSV_SELECT = "csv/select";
  static final String SUBRESOURCE_CSV_META = "csv/meta";
  static final String SUBRESOURCE_JSON_SELECT = "json/select";
  static final String SUBRESOURCE_JSON_META = "json/meta";
  static final String SUBRESOURCE_SQL = "sql";
  static final String SUBRESOURCE_SYMLINK = "symlink";
  static final String SUBRESOURCE_STAT = "stat";
  static final String SUBRESOURCE_RESTORE = "restore";
  static final String SUBRESOURCE_ENCRYPTION = "encryption";
  static final String SUBRESOURCE_VRESIONS = "versions";
  static final String SUBRESOURCE_VRESIONING = "versioning";
  static final String SUBRESOURCE_VRESION_ID = "versionId";
  static final String SUBRESOURCE_POLICY = "policy";
  static final String SUBRESOURCE_REQUEST_PAYMENT = "requestPayment";
  static final String SUBRESOURCE_QOS_INFO = "qosInfo";
  static final String SUBRESOURCE_ASYNC_FETCH = "asyncFetch";
  static final String SUBRESOURCE_INVENTORY = "inventory";
  static final String SUBRESOURCE_INVENTORY_ID = "inventoryId";
  static final String SUBRESOURCE_CONTINUATION_TOKEN = "continuation-token";
  static final String SUBRESOURCE_WORM = "worm";
  static final String SUBRESOURCE_WORM_ID = "wormId";
  static final String SUBRESOURCE_WORM_EXTEND = "wormExtend";
  static final String SUBRESOURCE_CALLBACK = "callback";
  static final String SUBRESOURCE_CALLBACK_VAR = "callback-var";
  static final String SUBRESOURCE_DIR_DELETE = "x-oss-delete";
  static final String SUBRESOURCE_RENAME = "x-oss-rename";
  static final String SUBRESOURCE_DIR = "x-oss-dir";
  static final String SUBRESOURCE_RESOURCE_GROUP = "resourcegroup";

  static final String SUBRESOURCE_UDF = "udf";
  static final String SUBRESOURCE_UDF_NAME = "udfName";
  static final String SUBRESOURCE_UDF_IMAGE = "udfImage";
  static final String SUBRESOURCE_UDF_IMAGE_DESC = "udfImageDesc";
  static final String SUBRESOURCE_UDF_APPLICATION = "udfApplication";
  static final String SUBRESOURCE_UDF_LOG = "udfApplicationLog";

  static final String PREFIX = "prefix";
  static final String DELIMITER = "delimiter";
  static final String MARKER = "marker";
  static final String MAX_KEYS = "max-keys";
  static final String BID = "bid";
  static final String ENCODING_TYPE = "encoding-type";
  static final String VERSION_ID_MARKER = "version-id-marker";
  static final String TAG_KEY = "tag-key";
  static final String TAG_VALUE = "tag-value";

  static final String UPLOAD_ID = "uploadId";
  static final String PART_NUMBER = "partNumber";
  static final String MAX_UPLOADS = "max-uploads";
  static final String UPLOAD_ID_MARKER = "upload-id-marker";
  static final String KEY_MARKER = "key-marker";
  static final String MAX_PARTS = "max-parts";
  static final String PART_NUMBER_MARKER = "part-number-marker";
  static final String RULE_ID = "rule-id";
  static final String SEQUENTIAL = "sequential";

  static final String SECURITY_TOKEN = "security-token";

  static final String POSITION = "position";
  static final String STYLE_NAME = "styleName";

  static final String COMP_ADD = "add";
  static final String COMP_DELETE = "delete";
  static final String COMP_CREATE = "create";
  static final String COMP_UPGRADE = "upgrade";
  static final String COMP_RESIZE = "resize";

  static final String STAT = "stat";
  static final String HISTORY = "history";
  static final String PLAYLIST_NAME = "playlistName";
  static final String SINCE = "since";
  static final String TAIL = "tail";

  /*  V1 signature params */
  static final String SIGNATURE = "Signature";
  static final String OSS_ACCESS_KEY_ID = "OSSAccessKeyId";

  /*  V2 signature params */
  static final String OSS_SIGNATURE_VERSION = "x-oss-signature-version";
  static final String OSS_EXPIRES = "x-oss-expires";
  static final String OSS_ACCESS_KEY_ID_PARAM = "x-oss-access-key-id";
  static final String OSS_ADDITIONAL_HEADERS = "x-oss-additional-headers";
  static final String OSS_SIGNATURE = "x-oss-signature";

  static final String OSS_TRAFFIC_LIMIT = "x-oss-traffic-limit";
  static final String OSS_REQUEST_PAYER = "x-oss-request-payer";

  static final String VPCIP = "vpcip";
  static final String VIP = "vip";

  /* listObjectsV2 params */
  static final String LIST_TYPE = "list-type";
  static final String START_AFTER = "start-after";
  static final String FETCH_OWNER = "fetch-owner";
  static final String SUBRESOURCE_TRANSFER_ACCELERATION =
      "transferAcceleration";
}
