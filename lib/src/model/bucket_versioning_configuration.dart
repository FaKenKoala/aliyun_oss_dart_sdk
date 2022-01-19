/// Represents the versioning configuration for a bucket.
/// <p>
/// A bucket's versioning configuration can be in one of three possible states:
///  <ul>
///      <li>{@link BucketVersioningConfiguration#OFF}
///      <li>{@link BucketVersioningConfiguration#ENABLED}
///      <li>{@link BucketVersioningConfiguration#SUSPENDED}
///  </ul>
/// </p>
/// <p>
/// By default, new buckets are in the
/// {@link BucketVersioningConfiguration#OFF off} state. Once versioning is
/// enabled for a bucket the status can never be reverted to
/// {@link BucketVersioningConfiguration#OFF off}.
/// </p>
/// <p>
/// The versioning configuration of a bucket has different implications for each
/// operation performed on that bucket or for objects within that bucket. For
/// instance, when versioning is enabled, a PutObject operation creates a unique
/// object version-id for the object being uploaded. The PutObject API guarantees
/// that, if versioning is enabled for a bucket at the time of the request, the
/// new object can only be permanently deleted using the DeleteVersion operation.
/// It can never be overwritten. Additionally, PutObject guarantees that, if
/// versioning is enabled for a bucket the request, no other object will be
/// overwritten by that request. Refer to the documentation sections for each API
/// for information on how versioning status affects the semantics of that
/// particular API.
/// <p>
/// OSS is eventually consistent. It may take time for the versioning status of a
/// bucket to be propagated throughout the system.
///
/// @see com.aliyun.oss.OSS#getBucketVersioning(String)
/// @see com.aliyun.oss.OSS#setBucketVersioning(SetBucketVersioningRequest)
class BucketVersioningConfiguration {
  /// OSS bucket versioning status indicating that versioning is off for a
  /// bucket. By default, all buckets start off with versioning off. Once you
  /// enable versioning for a bucket, you can never set the status back to
  /// "Off". You can only suspend versioning on a bucket once you've enabled.
  static const String off = "Off";

  /// OSS bucket versioning status indicating that versioning is suspended for a
  /// bucket. Use the "Suspended" status when you want to disable versioning on
  /// a bucket that has versioning enabled.
  static const String suspended = "Suspended";

  /// OSS bucket versioning status indicating that versioning is enabled for a
  /// bucket.
  static const String enabled = "Enabled";

  /// The current status of versioning
  String status;

  BucketVersioningConfiguration([this.status = off]);
}
