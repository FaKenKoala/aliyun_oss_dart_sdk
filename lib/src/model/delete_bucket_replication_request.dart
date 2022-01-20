import 'generic_request.dart';

/// The request that is to delete cross region's bucket replication.
class DeleteBucketReplicationRequest extends GenericRequest {
  DeleteBucketReplicationRequest(String bucketName, this.replicationRuleID)
      : super(bucketName: bucketName);

  String replicationRuleID;
}
