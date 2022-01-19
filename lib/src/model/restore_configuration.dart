import 'restore_job_parameters.dart';

class RestoreConfiguration {
  /// How many days will it stay in retrievable state after restore done.
  int days;

  /// The restore parameters.
  RestoreJobParameters? restoreJobParameters;

  RestoreConfiguration(this.days, [this.restoreJobParameters]);
}
