class UdfImageInfo {
  UdfImageInfo(
    this.version,
    this.status,
    this.desc,
    this.canonicalRegion,
    this.creationDate,
  );

  @override
  String toString() {
    return "UdfImageInfo [version=$version, status=$status, desc=$desc, canonicalRegion=$canonicalRegion, creationDate=$creationDate]";
  }

  int? version;
  String? status;
  String? desc;
  String? canonicalRegion;
  DateTime? creationDate;
}
