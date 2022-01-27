class PartETag {
  int partNumber;

  String? eTag;

  int partSize = 0;

  String? crc64 ;

  PartETag(this.partNumber, this.eTag);
}
