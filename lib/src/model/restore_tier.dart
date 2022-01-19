/// The restore priority.
enum RestoreTier {
  /// The restore job will be done in one hour.
  expedited,

  /// The restore job will be done in five hours.
  standard,

  /// The restore job will be done in ten hours.
  bulk,
}

extension RestoreTierX on RestoreTier {
  String get customName {
    switch (this) {
      case RestoreTier.expedited:
        return "Expedited";
      case RestoreTier.standard:
        return "Standard";
      case RestoreTier.bulk:
        return "Bulk";
    }
  }

  static RestoreTier parse(String tier) {
    for (RestoreTier o in RestoreTier.values) {
      if (o.customName.toLowerCase() == tier.toLowerCase()) {
        return o;
      }
    }

    throw ArgumentError("Unable to parse the RestoreTier text :$tier");
  }
}
