import 'crypto_scheme.dart';

class AesCtr extends CryptoScheme {
  @override
  String getKeyGeneratorAlgorithm() {
    return "AES";
  }

  @override
  int getKeyLengthInBits() {
    return 256;
  }

  @override
  String getContentChiperAlgorithm() {
    return "AES/CTR/NoPadding";
  }

  @override
  int getContentChiperIVLength() {
    return 16;
  }

  @override
  List<int> adjustIV(List<int> iv, int dataStartPos) {
    if (iv.length != 16) {
      throw UnsupportedOperationException();
    }

    final int blockSize = BLOCK_SIZE;
    int remainder = dataStartPos % blockSize;
    if (remainder != 0) {
      throw ArgumentError(
          "Expected data start pos should be multiple of 16,but it was: $dataStartPos");
    }

    int blockOffset = dataStartPos ~/ blockSize;
    List<int> J0 = computeJ0(iv);
    return incrementBlocks(J0, blockOffset);
  }

  List<int> computeJ0(List<int> nonce) {
    final int blockSize = BLOCK_SIZE;
    List<int> J0 = List.filled(blockSize, 0);

    System.arraycopy(nonce, 0, J0, 0, nonce.length);
    return J0;
  }
}
