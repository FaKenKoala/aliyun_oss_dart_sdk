import 'generic_request.dart';
import 'inventory_configuration.dart';

/// Request object to set an inventory configuration to a bucket.
class SetBucketInventoryConfigurationRequest extends GenericRequest {
  InventoryConfiguration? inventoryConfiguration;

  SetBucketInventoryConfigurationRequest(
      String bucketName, this.inventoryConfiguration)
      : super(bucketName: bucketName);
}
