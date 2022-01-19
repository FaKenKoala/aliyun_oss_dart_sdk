import 'generic_result.dart';
import 'replication_status.dart';

/// The progress of cross region bucket replication.
/// <p>
/// For historical data, it uses the percentage (e.g. 0.85 means 85%) of copied
/// file count as the progress indicator. It's only applicable for buckets
/// enabled with historical data replication. For new coming data, it uses the
/// replicated timestamp as the progress indicator. It means all files which are
/// uploaded before that timestamp have been replicated to the target bucket.
 class BucketReplicationProgress extends GenericResult {
     String? replicationRuleID;
     ReplicationStatus? replicationStatus;
     String? targetBucketName;
     String? targetBucketLocation;
     String? targetCloud;
     String? targetCloudLocation;
     bool? enableHistoricalObjectReplication;

     double? historicalObjectProgress;
     DateTime? newObjectProgress;
}
