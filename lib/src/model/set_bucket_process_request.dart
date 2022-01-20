import 'generic_request.dart';
import 'image_process.dart';

class SetBucketProcessRequest extends GenericRequest {
  SetBucketProcessRequest(String bucketName, this.imageProcess)
      : super(bucketName: bucketName);

  ImageProcess imageProcess;
}
