import 'inventoryPformat.dart';
import 'inventory_encryption.dart';

/// Contains the bucket name, file format, bucket owner (optional),
/// prefix (optional) and encryption (optional) where inventory results are published.
class InventoryOSSBucketDestination {
  String? accountId;

  String? roleArn;

  String? bucket;

  String? format;

  String? prefix;

  InventoryEncryption? encryption;

  /// Sets the output format of the inventory results.
  void setFormat(InventoryFormat? format) {
    this.format = format?.name;
  }
}
