
import 'package:aliyun_oss_dart_sdk/src/crypto/crypto_module_base.dart';

import 'content_crypto_mode.dart';
import 'crypto_configuration.dart';
import 'encryption_materials.dart';
import 'oss_direct.dart';

/// The crypto module specified to AES_CTR crypto shecme.
/// that it will encrypt content with AES_CTR algothrim.
class CryptoModuleAesCtr extends CryptoModuleBase {    
    CryptoModuleAesCtr(OSSDirect oss,
                     EncryptionMaterials encryptionMaterials,
                     CryptoConfiguration cryptoConfig) :
        super(oss, encryptionMaterials, cryptoConfig);
    

    /// @return an array of bytes representing the content crypto cipher start counter.
    @override
     List<int> generateIV() {
        final List<int> iv = List.filled(contentCryptoScheme.getContentChiperIVLength(), 0);
        cryptoConfig.getSecureRandom().nextBytes(iv);
        if (cryptoConfig.getContentCryptoMode().equals(ContentCryptoMode.AES_CTR_MODE)) {
            for (int i = 8; i < 12; i++) {
                iv[i] = 0;
            }
        }
        return iv;
    }

    ///Creates a cipher from a {@link ContentCryptoMaterial} instance, it used to encrypt/decrypt data.
    ///
    /// @param cekMaterial
    ///             It provides the cek iv and crypto algorithm to build an crypto cipher.
    /// @param cipherMode
    ///             Cipher.ENCRYPT_MODE or Cipher.DECRYPT_MODE
    /// @param cryptoRange
    ///             The first element of the crypto range is the offset of the acquired object,
    ///             and it should be allgned with cipher block if it was not null.
    /// @param skipBlock
    ///              the number of blocks should be skiped when the cipher created.
    /// @return a {@link CryptoCipher} instance for encrypt/decrypt data.         
     CryptoCipher createCryptoCipherFromContentMaterial(ContentCryptoMaterial cekMaterial, int cipherMode,
            long[] cryptoRange, long skipBlock) {
        if (cipherMode != Cipher.ENCRYPT_MODE && cipherMode != Cipher.DECRYPT_MODE) {
            throw new ClientException("Invalid cipher mode.");
        }
        byte[] iv = cekMaterial.getIV();
        SecretKey cek = cekMaterial.getCEK();
        String cekAlgo = cekMaterial.getContentCryptoAlgorithm();
        CryptoScheme tmpContentCryptoScheme = CryptoScheme.fromCEKAlgo(cekAlgo);
        // Adjust the IV if needed
        bool isRangeGet = (cryptoRange != null);
        if (isRangeGet) {
            iv = tmpContentCryptoScheme.adjustIV(iv, cryptoRange[0]);
        } else if (skipBlock > 0) {
            iv = CryptoScheme.incrementBlocks(iv, skipBlock);
        }
        return tmpContentCryptoScheme.createCryptoCipher(cek, iv, cipherMode, cryptoConfig.getContentCryptoProvider());
    }
}
