import 'generic_request.dart';

class CompleteBucketWormRequest extends GenericRequest {
  String wormId;

  CompleteBucketWormRequest(String bucketName, this.wormId)
      : super(bucketName: bucketName);
}
