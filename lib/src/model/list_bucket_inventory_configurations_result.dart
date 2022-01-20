import 'generic_result.dart';
import 'inventory_configuration.dart';

/// Result of the list bucket inventory configuration opreation.
class ListBucketInventoryConfigurationsResult extends GenericResult {
  /// The list of inventory configurations for a bucket.
  List<InventoryConfiguration>? inventoryConfigurationList;

  /// Optional parameter which allows list to be continued from a specific point.
  /// This is the continuationToken that was sent in the current
  String? continuationToken;

  /// Indicates if this is a truncated listing or not。
  bool? isTruncated;

  /// NextContinuationToken is sent when isTruncated is true meaning there are
  /// more inventory configurations in the bucket that can be listed.
  String? nextContinuationToken;
}
