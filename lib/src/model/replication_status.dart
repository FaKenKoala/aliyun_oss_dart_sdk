/// The status of cross region replication.
/// <p>
/// Currently we have starting，doing，closing three status. After
/// PutBucketReplication is sent, OSS start preparing the replication and at this
/// point the status is 'starting'. And when the replication actually happens,
/// the status is "doing". And once DeleteBucketReplication is called, the OSS
/// will do the cleanup work for the replication and the status will be
/// "closing".
/// </p>
///
///
enum ReplicationStatus {
  starting,

  doing,

  closing,
}

extension ReplicationStatusX on ReplicationStatus {
  static ReplicationStatus parse(String replicationStatus) {
    for (ReplicationStatus status in ReplicationStatus.values) {
      if (status.name == replicationStatus) {
        return status;
      }
    }

    throw ArgumentError(
        "Unable to parse the provided replication status $replicationStatus");
  }
}
