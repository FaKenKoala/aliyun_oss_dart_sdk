import 'content_crypto_material.dart';

class MultipartUploadCryptoContext {
  String? uploadId;
  ContentCryptoMaterial? cekMaterial;
  int partSize = 0;
  int dataSize = 0;

  @override
  int get hashCode {
    final int prime = 31;
    int result = 1;
    result = prime * result + partSize;
    result = prime * result + dataSize;
    result = prime * result + (uploadId?.hashCode ?? 0);
    result = prime * result + (cekMaterial?.hashCode ?? 0);
    return result;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is MultipartUploadCryptoContext &&
            other.uploadId == uploadId &&
            other.cekMaterial == cekMaterial &&
            other.dataSize == dataSize &&
            other.partSize == partSize;
  }
}
