class PublicKey {
  PublicKey({this.keyId, this.keySpec, this.status, this.createDate});

  //  PublicKey(com.aliyuncs.ram.model.v20150501.ListPublicKeysResponse.PublicKey listPublicKey) {
  //     this(listPublicKey.getPublicKeyId(), listPublicKey.getStatus(), listPublicKey.getCreateDate());
  // }

  //  PublicKey(com.aliyuncs.ram.model.v20150501.UploadPublicKeyResponse.PublicKey respPublicKey) {
  //     this(respPublicKey.getPublicKeyId(), respPublicKey.getPublicKeySpec(), respPublicKey.getStatus(),
  //             respPublicKey.getCreateDate());
  // }

  String? keyId;
  String? keySpec;
  String? status;
  String? createDate;
}
