import 'generic_request.dart';

/// Request object to delete an inventory configuration.
class DeleteBucketInventoryConfigurationRequest extends GenericRequest {
  String inventoryId;

  DeleteBucketInventoryConfigurationRequest(String bucketName, this.inventoryId)
      : super(bucketName: bucketName);
}
