import 'inventory_destination.dart';
import 'inventory_filter.dart';
import 'inventory_included_object_versions.dart';
import 'inventory_schedule.dart';

class InventoryConfiguration {
  /// The ID used to identify the inventory configuration.
  String? inventoryId;

  /// Contains information about where to publish the inventory results.
  InventoryDestination? destination;

  /// Specifies whether the inventory is enabled or disabled.
  bool? isEnabled;

  /// Specifies an inventory filter.
  InventoryFilter? inventoryFilter;

  /// Specifies which object version(s) to included in the inventory results.
  String? includedObjectVersions;

  /// List to store the optional fields that are included in the inventory results.
  List<String>? optionalFields;

  /// Specifies the schedule for generating inventory results.
  InventorySchedule? schedule;

  void setIncludedObjectVersions(
      InventoryIncludedObjectVersions? includedObjectVersions) {
    this.includedObjectVersions = includedObjectVersions?.name;
  }

  void addOptionalField(String? optionalField) {
    if (optionalField == null) {
      return;
    }
    optionalFields ??= [];
    optionalFields!.add(optionalField);
  }
}
