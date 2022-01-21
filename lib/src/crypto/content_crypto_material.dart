import 'package:cryptography/cryptography.dart';
import 'package:collection/collection.dart';

/// Content crypto material used for client-side content encryption/decryption in OSS,
/// it only provide getting accessor.
class ContentCryptoMaterial {
  /// Prevent sensitive information serializing.
  SecretKey? _cek;

  /// Prevent sensitive information serializing.*/
  List<int>? iv;
  String? contentCryptoAlgorithm;
  List<int>? encryptedCEK;
  List<int>? encryptedIV;
  String? keyWrapAlgorithm;
  Map<String, String>? matdesc;

  /// 用于计算hashCode
  List<int> _cekBytes = [];

  ContentCryptoMaterial(
      [SecretKey? cek,
      List<int> iv = const [],
      this.contentCryptoAlgorithm,
      List<int> encryptedCEK = const [],
      List<int> encryptedIV = const [],
      this.keyWrapAlgorithm,
      Map<String, String>? matDesc]) {
    this.cek = cek;
    this.iv = List.from(iv);
    contentCryptoAlgorithm = contentCryptoAlgorithm;
    this.encryptedIV = List.from(encryptedCEK);
    keyWrapAlgorithm = keyWrapAlgorithm;
    matdesc = UnmodifiableMapView(matdesc ?? {});
  }

  SecretKey? get cek => _cek;

  set cek(SecretKey? cek) {
    _cek = cek;
    initCekBytes();
  }

  initCekBytes() async {
    if (cek != null) {
      _cekBytes = await cek!.extractBytes();
    }
  }

  @override
  int get hashCode {
    final int prime = 31;
    int result = 1;

    if (cek != null) {
      for (int i = 0; i < _cekBytes.length; i++) {
        result = prime * result + _cekBytes[i];
      }
    }

    if (iv != null) {
      for (int i = 0; i < iv!.length; i++) {
        result = prime * result + iv![i];
      }
    }

    if (encryptedCEK != null) {
      for (int i = 0; i < encryptedCEK!.length; i++) {
        result = prime * result + encryptedCEK![i];
      }
    }

    if (encryptedIV != null) {
      for (int i = 0; i < encryptedIV!.length; i++) {
        result = prime * result + encryptedIV![i];
      }
    }

    result = prime * result + (contentCryptoAlgorithm?.hashCode ?? 0);
    result = prime * result + (keyWrapAlgorithm?.hashCode ?? 0);
    result = prime * result + (matdesc?.hashCode ?? 0);
    return result;
  }

  @override
  bool operator ==(Object other) {
    DeepCollectionEquality equality = DeepCollectionEquality();
    return identical(this, other) ||
        other is ContentCryptoMaterial &&
            other.cek == cek &&
            equality.equals(iv, other.iv) &&
            other.contentCryptoAlgorithm == contentCryptoAlgorithm &&
            equality.equals(encryptedCEK, other.encryptedCEK) &&
            equality.equals(encryptedIV, other.encryptedIV) &&
            other.keyWrapAlgorithm == keyWrapAlgorithm &&
            equality.equals(matdesc, other.matdesc);
  }
}
