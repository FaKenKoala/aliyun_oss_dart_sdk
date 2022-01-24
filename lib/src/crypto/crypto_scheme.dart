
 import 'aes_ctr.dart';

abstract class CryptoScheme {
    // Enable bouncy castle provider
    static {
        CryptoRuntime.enableBouncyCastle();
    }

     static final int BLOCK_SIZE = 16;
     static final CryptoScheme AES_CTR = AesCtr();

      String getKeyGeneratorAlgorithm();

      int getKeyLengthInBits();

      String getContentChiperAlgorithm();

      int getContentChiperIVLength();

      List<int> adjustIV(List<int> iv, int dataStartPos);

    /// This is a factory method to create CryptoCipher.
     CryptoCipher newCryptoCipher(Cipher cipher, SecretKey cek, int cipherMode) {
        return CryptoCipher(cipher, this, cek, cipherMode);
    }

     CryptoCipher createCryptoCipher(SecretKey cek, List<int> iv, int cipherMode, Provider provider) {
        try {
            Cipher? cipher;
            if (provider != null) {
                cipher = Cipher.getInstance(getContentChiperAlgorithm(), provider);
            } else {
                cipher = Cipher.getInstance(getContentChiperAlgorithm());
            }
            cipher.init(cipherMode, cek, IvParameterSpec(iv));
            return newCryptoCipher(cipher, cek, cipherMode);
        } catch ( e) {
            throw ClientException("Unable to build cipher: " + e.getMessage(), e);
        }
    }

    /// Increment the rightmost 64 bits of a 16-byte counter by the specified delta.
    /// Both the specified delta and the resultant value must stay within the
    /// capacity of 64 bits. (Package  for testing purposes.)
    ///
    /// @param counter
    ///            a 16-byte counter.
    /// @param blockDelta
    ///            the number of blocks (16-byte) to increment
     static List<int> incrementBlocks(List<int>? counter, int blockDelta) {
        if (blockDelta == 0) {
          return counter ?? [];
        }
        if (counter == null || counter.length != 16) {
          throw ArgumentError();
        }

        ByteBuffer bb = ByteBuffer.allocate(8);
        for (int i = 12; i <= 15; i++) {
          bb.PUT(i - 8, counter[i]);
        }
        int val = bb.getint() + blockDelta; // increment by delta
        bb.rewind();
        List<int> result = bb.putint(val).array();

        for (int i = 8; i <= 15; i++) {
          counter[i] = result[i - 8];
        }
        return counter;
    }

     static CryptoScheme fromCEKAlgo(String cekAlgo) {
        if (AES_CTR.getContentChiperAlgorithm() == cekAlgo) {
            return AES_CTR;
        }
        throw UnsupportedOperationException("Unsupported content encryption scheme: " + cekAlgo);
    }
}
