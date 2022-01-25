import 'package:cryptography/cryptography.dart';

import 'crypto_scheme.dart';

class CryptoCipher {
  static const CryptoCipher Null = CryptoCipher();
  final Cipher cipher;
  final CryptoScheme? scheme;
  final SecretKey? secreteKey;
  final int cipherMode;

  CryptoCipher(
      [final CryptoCipher? cipher,
      this.scheme,
      this.secreteKey,
      this.cipherMode = -1])
      : cipher = cipher ?? Null;

  /// Recreates a new instance of CipherLite from the current one.
  CryptoCipher recreate() {
    return scheme.createCryptoCipher(
        secreteKey, cipher.getIV(), cipherMode, cipher.getProvider());
  }

  List<int> doFinal() {
    return cipher.doFinal();
  }

  /// Continues a multiple-part encryption or decryption operation (depending on
  /// how the underlying cipher was initialized), processing another data part.
  ///
  /// <p>
  /// The first <code>inputLen</code> bytes in the <code>input</code> buffer,
  /// starting at <code>inputOffset</code> inclusive, are processed, and the result
  /// is stored in a new buffer.
  ///
  /// <p>
  /// If <code>inputLen</code> is zero, this method returns <code>null</code>.
  ///
  /// @param input
  ///            the input buffer
  /// @param inputOffset
  ///            the offset in <code>input</code> where the input starts
  /// @param inputLen
  ///            the input length
  ///
  /// @return the new buffer with the result, or null if the underlying cipher is a
  ///         block cipher and the input data is too short to result in a new
  ///         block.
  ///
  /// @exception IllegalStateException
  ///                if the underlying cipher is in a wrong state (e.g., has
  ///                not been initialized)
  List<int> update(List<int> input, int inputOffset, int inputLen) {
    return cipher.update(input, inputOffset, inputLen);
  }
}
