import 'bucket_qos_info.dart';
import 'generic_request.dart';

class SetBucketQosInfoRequest extends GenericRequest {
  BucketQosInfo? bucketQosInfo;

  SetBucketQosInfoRequest(String bucketName, [this.bucketQosInfo])
      : super(bucketName: bucketName);
}
