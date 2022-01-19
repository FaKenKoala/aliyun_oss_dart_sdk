class PartETag {
  int partNumber;
  String? eTag;
  int partSize;
  int? partCRC;

  PartETag(this.partNumber, this.eTag, [this.partSize = 0, this.partCRC]);

  /// TODO: wombat加的，不加下面的hashCode会报warning
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PartETag &&
            other.partNumber == partNumber &&
            other.eTag == eTag;
  }

  @override
  int get hashCode {
    final int prime = 31;
    int result = 1;
    result = (prime * result + (eTag?.hashCode ?? 0)).toInt();
    result = prime * result + partNumber;
    return result;
  }
}
