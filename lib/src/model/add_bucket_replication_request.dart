// ignore_for_file: constant_identifier_names

import 'generic_request.dart';

/// The request class that is used to add a cross region replication request on a
/// bucket.
class AddBucketReplicationRequest extends GenericRequest {
  AddBucketReplicationRequest(String bucketName)
      : super(bucketName: bucketName);

  List<String> get objectPrefixList => _objectPrefixList;

  void setObjectPrefixList(List<String>? objectPrefixList) {
    _objectPrefixList
      ..clear
      ..addAll(objectPrefixList ?? []);
  }

  List<ReplicationAction> get replicationActionList => _replicationActionList;

  set replicationActionList(List<ReplicationAction>? replicationActionList) {
    _replicationActionList
      ..clear()
      ..addAll(replicationActionList ?? []);
  }

  static final String disabled = "Disabled";
  static final String enabled = "Enabled";

  String replicationRuleID = "";
  String? targetBucketName;
  String? targetBucketLocation;
  String? targetCloud;
  String? targetCloudLocation;
  bool enableHistoricalObjectReplication = true;
  final List<String> _objectPrefixList = [];
  final List<ReplicationAction> _replicationActionList = [];
  String? syncRole;
  String? replicaKmsKeyID;
  String? sseKmsEncryptedObjectsStatus;
  String? sourceBucketLocation;
}

enum ReplicationAction {
  /// All PUT, DELETE, ABORT operations would be copied to the target
  /// bucket.
  ALL,

  /// Includes PutObject/PostObject/AppendObject/CopyObject/PutObjectACL/
  /// InitiateMultipartUpload/UploadPart/UploadPartCopy/
  /// CompleteMultipartUpload。
  PUT,

  /// Includes DeleteObject/DeleteMultipleObjects.
  DELETE,

  /// Includes CompleteMultipartUpload，AbortMultipartUpload.
  ABORT,
}

extension ReplicationActionX on ReplicationAction {
  static ReplicationAction parse(String replicationAction) {
    for (ReplicationAction rt in ReplicationAction.values) {
      if (rt.name == replicationAction) {
        return rt;
      }
    }

    throw ArgumentError("Unable to parse $replicationAction");
  }
}
