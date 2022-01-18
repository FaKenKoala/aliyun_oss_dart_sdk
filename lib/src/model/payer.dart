enum Payer {
  bucketOwner,
  requester,
}

Payer parse(String name) {
  for (Payer payer in Payer.values) {
    if (payer.name.toLowerCase() == name.toLowerCase()) {
      return payer;
    }
  }
  throw ArgumentError('Unable to parse the payer text $name');
}
