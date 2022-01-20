import 'bucket_versioning_configuration.dart';
import 'generic_request.dart';

class SetBucketVersioningRequest extends GenericRequest {
  /// The new versioning configuration for the specified bucket.
  BucketVersioningConfiguration versioningConfiguration;

  SetBucketVersioningRequest(String bucketName, this.versioningConfiguration)
      : super(bucketName: bucketName);
}
