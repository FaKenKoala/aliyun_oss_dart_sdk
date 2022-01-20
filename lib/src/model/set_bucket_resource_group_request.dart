import 'generic_request.dart';

class SetBucketResourceGroupRequest extends GenericRequest {
  // The id of resource group
  String? resourceGroupId;

  SetBucketResourceGroupRequest(String bucketName, [this.resourceGroupId])
      : super(bucketName: bucketName);
}
