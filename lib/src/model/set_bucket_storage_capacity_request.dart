import 'generic_request.dart';
import 'user_qos.dart';

class SetBucketStorageCapacityRequest extends GenericRequest {
  SetBucketStorageCapacityRequest(String bucketName)
      : super(bucketName: bucketName);

  UserQos? userQos;
}
