import 'generic_request.dart';
import 'server_side_encryption_configuration.dart';

/// Represents the input of a <code>PutBucketEncryption</code> operation.
class SetBucketEncryptionRequest extends GenericRequest {
  ServerSideEncryptionConfiguration? serverSideEncryptionConfiguration;

  SetBucketEncryptionRequest(String bucketName,
      [this.serverSideEncryptionConfiguration])
      : super(bucketName: bucketName);
}
