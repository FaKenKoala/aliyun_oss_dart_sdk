import 'add_bucket_replication_request.dart';
import 'replication_status.dart';

/// The cross region replication rules on a bucket.
class ReplicationRule {
  List<String> get objectPrefixList {
    return _objectPrefixList;
  }

  set objectPrefixList(List<String>? objectPrefixList) {
    _objectPrefixList = [];
    _objectPrefixList.addAll(objectPrefixList ?? []);
  }

  List<ReplicationAction> get replicationActionList {
    return _replicationActionList;
  }

  set replicationActionList(List<ReplicationAction>? replicationActionList) {
    _replicationActionList = [];
    _replicationActionList.addAll(replicationActionList ?? []);
  }

  String? replicationRuleID;
  ReplicationStatus? replicationStatus;
  String? targetBucketName;
  String? targetBucketLocation;
  String? targetCloud;
  String? targetCloudLocation;
  bool enableHistoricalObjectReplication = false;
  List<String> _objectPrefixList = [];
  List<ReplicationAction> _replicationActionList = [];
  String? syncRole;
  String? replicaKmsKeyID;
  String? sseKmsEncryptedObjectsStatus;
  String? sourceBucketLocation;
}
