import 'generic_request.dart';

/// This request class is used to get the bucket replication progress information
/// from OSS.
class GetBucketReplicationProgressRequest extends GenericRequest {
  GetBucketReplicationProgressRequest(String bucketName,
      [this.replicationRuleID])
      : super(bucketName: bucketName);

  String? replicationRuleID;
}
