import 'canned_access_control_list.dart';
import 'data_redundancy_type.dart';
import 'generic_request.dart';
import 'storage_class.dart';

class CreateBucketRequest extends GenericRequest {
  String? locationConstraint;
  CannedAccessControlList? cannedACL;
  StorageClass? storageClass;
  DataRedundancyType? dataRedundancyType;
  String? hnsStatus;
  String? resourceGroupId;

  CreateBucketRequest(String bucketName) : super(bucketName: bucketName);
}
