import 'generic_request.dart';

/// Request object to list inventory configurations of a bucket.
class ListBucketInventoryConfigurationsRequest extends GenericRequest {
  /// Optional parameter which allows list to be continued from a specific point.
  /// ContinuationToken is provided in truncated list results.
  String? continuationToken;

  ListBucketInventoryConfigurationsRequest(String bucketName,
      [this.continuationToken])
      : super(bucketName: bucketName);
}
