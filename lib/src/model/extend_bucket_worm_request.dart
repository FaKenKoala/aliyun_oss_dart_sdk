import 'generic_request.dart';

class ExtendBucketWormRequest extends GenericRequest {
  String? wormId;
  int retentionPeriodInDays;

  ExtendBucketWormRequest(String bucketName,
      [this.wormId, this.retentionPeriodInDays = 0])
      : super(bucketName: bucketName);

}
