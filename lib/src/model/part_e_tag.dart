class PartETag {
  int partNumber;

  String eTag;

  int partSize = 0;

  int crc64 = 0;

  PartETag(this.partNumber, this.eTag);
}
