import 'bucket_referer.dart';
import 'generic_request.dart';

class SetBucketRefererRequest extends GenericRequest {
  BucketReferer? referer;

  SetBucketRefererRequest(String bucketName, [this.referer])
      : super(bucketName: bucketName);
}
