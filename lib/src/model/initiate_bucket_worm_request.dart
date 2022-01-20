import 'generic_request.dart';

class InitiateBucketWormRequest extends GenericRequest {
  int retentionPeriodInDays = 0;

  InitiateBucketWormRequest(String bucketName, [this.retentionPeriodInDays = 0])
      : super(bucketName: bucketName);
}
