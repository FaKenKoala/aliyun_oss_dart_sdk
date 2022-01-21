import 'content_crypto_material_rw.dart';

/// EncryptionMaterials is an interface used to implement different
/// encrypt/decrypt content materials providers.
abstract class EncryptionMaterials {
    /// Encrypt the cek and iv and put the result into the given {@link ContentCryptoMaterialRW} instance.
     void encryptCEK(ContentCryptoMaterialRW contentMaterial);

    /// Decrypt the secured cek and secured iv and put the result into the given {@link ContentCryptoMaterialRW} 
    /// instance
     void decryptCEK(ContentCryptoMaterialRW contentMaterial);
}