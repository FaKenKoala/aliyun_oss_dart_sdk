import 'restore_tier.dart';

/// The job parameters of restoring the {@link StorageClass#ColdArchive} object. If the restore job parameters
/// has not be specified, the default restore priority is {@link RestoreTier#RESTORE_TIER_STANDARD}.
class RestoreJobParameters {
  RestoreJobParameters(this.restoreTier);

  /// The priority of restore the {@link StorageClass#ColdArchive} object job.
  RestoreTier restoreTier;
}
