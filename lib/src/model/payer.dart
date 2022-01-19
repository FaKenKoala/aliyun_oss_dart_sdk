enum Payer {
  bucketOwner,
  requester,
}

extension PayerX on Payer {
  String get customName {
    switch (this) {
      case Payer.bucketOwner:
        return "BucketOwner";
      case Payer.requester:
      default:
        return "Requester";
    }
  }

  static Payer parse(String name) {
  for (Payer payer in Payer.values) {
    if (payer.customName.toLowerCase() == name.toLowerCase()) {
      return payer;
    }
  }
  throw ArgumentError('Unable to parse the payer text $name');
}
}


