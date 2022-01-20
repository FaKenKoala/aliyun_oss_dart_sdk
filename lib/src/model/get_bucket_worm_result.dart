import 'generic_result.dart';

class GetBucketWormResult extends GenericResult {
  String? wormId;
  String? wormState;
  int retentionPeriodInDays = 0;

  DateTime? creationDate;
}
