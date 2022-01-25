import 'oss_request.dart';

class ImagePersistRequest extends OSSRequest {
  String fromBucket;

  String fromObjectKey;

  String toBucketName;

  String toObjectKey;

  String action;

  ImagePersistRequest(this.fromBucket, this.fromObjectKey, this.toBucketName,
      this.toObjectKey, this.action);
}
