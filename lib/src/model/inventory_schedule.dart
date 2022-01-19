import 'inventory_frequency.dart';

/// Schedule for generating inventory results.
class InventorySchedule {
  /// Specifies how frequently inventory results are produced.
  String? frequency;

  void setFrequency(InventoryFrequency? frequency) {
    this.frequency = frequency?.name;
  }
}
