import 'generic_result.dart';

/// Bucket Stat It contains the current bucket's occupant size and file count.
class BucketStat extends GenericResult {
  BucketStat(
    this.storageSize,
    this.objectCount,
    this.multipartUploadCount,
  );

  final int? storageSize; // bytes
  final int? objectCount;
  final int? multipartUploadCount;
}
