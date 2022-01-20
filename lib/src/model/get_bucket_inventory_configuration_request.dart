import 'generic_request.dart';

class GetBucketInventoryConfigurationRequest extends GenericRequest {
  String inventoryId;

  GetBucketInventoryConfigurationRequest(String bucketName, this.inventoryId)
      : super(bucketName: bucketName);
}
