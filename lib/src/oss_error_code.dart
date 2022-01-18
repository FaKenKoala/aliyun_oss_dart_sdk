abstract class OSSErrorCode {
  /// Access Denied (401)
  static final String accessDenied = "AccessDenied";

  /// Access Forbidden (403)
  static final String accessForbidden = "AccessForbidden";

  /// Bucket pre-exists
  static final String bucketAlreadyExists = "BucketAlreadyExists";

  /// Bucket not empty.
  static final String bucketNotEmpty = "BucketNotEmpty";

  /// File groups is too large.
  static final String fileGroupTooLarge = "FileGroupTooLarge";

  /// File part is stale.
  static final String filePartStale = "FilePartStale";

  /// Invalid argument.
  static final String invalidArgument = "InvalidArgument";

  /// Non-existing Access ID
  static final String invalidAccessKeyId = "InvalidAccessKeyId";

  /// Invalid bucket name
  static final String invalidBucketName = "InvalidBucketName";

  /// Invalid object name
  static final String invalidObjectName = "InvalidObjectName";

  /// Invalid part
  static final String invalidPart = "InvalidPart";

  /// Invalid part order
  static final String invalidPartOrder = "InvalidPartOrder";

  /// The target bucket does not exist when setting logging.
  static final String invalidTargetBucketForLogging =
      "InvalidTargetBucketForLogging";

  /// OSS Internal error.
  static final String internalError = "InternalError";

  /// Missing content length.
  static final String missingContentLength = "MissingContentLength";

  /// Missing required argument.
  static final String missingArgument = "MissingArgument";

  /// No bucket meets the requirement specified.
  static final String noSuchBucket = "NoSuchBucket";

  /// File does not exist.
  static final String noSuchKey = "NoSuchKey";

  /// Version does not exist.
  static final String noSuchVersion = "NoSuchVersion";

  /// Not implemented method.
  static final String notImplemented = "NotImplemented";

  /// Error occurred in precondition.
  static final String preconditionFailed = "PreconditionFailed";

  /// 304 Not Modified。
  static final String notModified = "NotModified";

  /// Invalid location.
  static final String invalidLocationConstraint = "InvalidLocationConstraint";

  /// The specified location does not match with the request.
  static final String illegalLocationConstraintException =
      "IllegalLocationConstraintException";

  /// The time skew between the time in request headers and server is more than 15 min.
  static final String requestTimeTooSkewed = "RequestTimeTooSkewed";

  /// Request times out.
  static final String requestTimeout = "RequestTimeout";

  /// Invalid signature.
  static final String signatureDoesNotMatch = "SignatureDoesNotMatch";

  /// Too many buckets under a user.
  static final String tooManyBuckets = "TooManyBuckets";

  /// Source buckets is not configured with CORS.
  static final String noSuchCorsConfiguration = "NoSuchCORSConfiguration";

  /// The source bucket is not configured with static website (the index page is null).
  static final String noSuchWebsiteConfiguration = "NoSuchWebsiteConfiguration";

  /// The source bucket is not configured with lifecycle rule.
  static final String noSuchLifecycle = "NoSuchLifecycle";

  /// Malformed xml.
  static final String malformedXml = "MalformedXML";

  /// Invalid encryption algorithm error.
  static final String invalidEncryptionAlgorithmError =
      "InvalidEncryptionAlgorithmError";

  /// The upload Id does not exist.
  static final String noSuchUpload = "NoSuchUpload";

  /// The entity is too small. (Part must be more than 100K)
  static final String entityTooSmall = "EntityTooSmall";

  /// The entity is too big.
  static final String entityTooLarge = "EntityTooLarge";

  /// Invalid MD5 digest.
  static final String invalidDigest = "InvalidDigest";

  /// Invalid range of the character.
  static final String invalidRange = "InvalidRange";

  /// Security token is not supported.
  static final String securityTokenNotSupported = "SecurityTokenNotSupported";

  /// The specified object does not support append operation.
  static final String objectNotAppendalbe = "ObjectNotAppendable";

  /// The position of append on the object is not same as the current length.
  static final String positionNotEqualToLength = "PositionNotEqualToLength";

  /// Invalid response.
  static final String invalidResponse = "InvalidResponse";

  /// Callback failed. The operation (such as download or upload) succeeded though.
  static final String callbackFailed = "CallbackFailed";

  /// The Live Channel does not exist.
  static final String noSuchLiveChannel = "NoSuchLiveChannel";

  /// symlink target file does not exist.
  static final String noSuchSymLinkTarget = "SymlinkTargetNotExist";

  /// The archive file is not restored before usage.
  static final String invalidObjectState = "InvalidObjectState";

  /// The policy text is illegal.
  static final String invalidPolicyDocument = "InvalidPolicyDocument";

  /// The exsiting bucket without policy.
  static final String noSuchBucketPolicy = "NoSuchBucketPolicy";

  /// The object has already exists.
  static final String objectAlreadyExists = "ObjectAlreadyExists";

  /// The exsiting bucket without inventory.
  static final String noSuchInventory = "NoSuchInventory";

  /// The part is not upload sequentially
  static final String partNotSequential = "PartNotSequential";

  /// The file is immutable.
  static final String fileImmutable = "FileImmutable";

  /// The worm configuration is locked.
  static final String wormConfigurationLocked = "WORMConfigurationLocked";

  /// The worm configuration is invalid.
  static final String invalidWormConfiguration = "InvalidWORMConfiguration";

  /// The file already exists.
  static final String fileAlreadyExists = "FileAlreadyExists";
}
