
import 'content_crypto_mode.dart';

/// The crypto configuration used to configure storage method of crypto info,
/// content crypto mode, secure random generator and content crypto provider.
 class CryptoConfiguration implements Cloneable {

     static final SecureRandom SRAND = SecureRandom();
     ContentCryptoMode contentCryptoMode;
     CryptoStorageMethod storageMethod;
     Provider contentCryptoProvider;
     SecureRandom secureRandom;

    /// Default crypto configuration.
     static final CryptoConfiguration DEFAULT = CryptoConfiguration();

     CryptoConfiguration() {
        this.contentCryptoMode = AES_CTR_MODE;
        this.storageMethod = CryptoStorageMethod.ObjectMetadata;
        this.secureRandom = SRAND;
        this.contentCryptoProvider = null;
    }

     CryptoConfiguration(ContentCryptoMode contentCryptoMode, 
                               CryptoStorageMethod storageMethod,
                               SecureRandom secureRandom,
                               Provider contentCryptoProvider) {
        this.contentCryptoMode = contentCryptoMode;
        this.storageMethod = storageMethod;
        this.secureRandom = secureRandom;
        this.contentCryptoProvider = contentCryptoProvider;
    }

    /// Sets the content crypto mode to the specified crypto mode.
    ///
    /// @param contentCryptoMode
    ///            the content crypto mode {@link ContentCryptoMode}.
     void setContentCryptoMode(ContentCryptoMode contentCryptoMode) {
        this.contentCryptoMode = contentCryptoMode;
    }

    /// Gets the content crypto mode to the specified crypto mode.
    ///
    /// @return contentCryptoMode
    ///            the content crypto mode {@link ContentCryptoMode}.
     ContentCryptoMode getContentCryptoMode() {
        return this.contentCryptoMode;
    }

    /// Sets the storage method to the specified storage method.
    ///
    /// @param storageMethod
    ///            the storage method of the cryto information sotoring.
     void setStorageMethod(CryptoStorageMethod storageMethod) {
        this.storageMethod = storageMethod;
    }

    /// Gets the storage method.
    /// 
    /// @return the storage method of the cryto information storing.
     CryptoStorageMethod getStorageMethod() {
        return this.storageMethod;
    }

    /// Sets the secure random to the specified secure random generator, and returns the updated
    /// CryptoConfiguration object.
    ///
    /// @param secureRandom
    ///            the secure random generator.
     void setSecureRandom(SecureRandom secureRandom) {
        this.secureRandom = secureRandom;
    }

    /// Sets the secure random to the specified secure random generator, and returns the updated
    /// CryptoConfiguration object.
    ///
    /// @param secureRandom
    ///            the secure random generator.
    /// @return The updated CryptoConfiguration object.
     CryptoConfiguration withSecureRandom(SecureRandom secureRandom) {
        this.secureRandom = secureRandom;
        return this;
    }

    /// Gets the secure random to the specified secure random generator.
    ///
    /// @return secureRandom
    ///            the secure random generator.
     SecureRandom getSecureRandom() {
        return secureRandom;
    }

    /// Sets the content crypto provider the specified provider.
    /// 
    /// @param contentCryptoProvider
    ///            The provider to be used for crypto content.
     void setContentCryptoProvider(Provider contentCryptoProvider) {
        this.contentCryptoProvider = contentCryptoProvider;
    }

    /// Sets the content crypto provider the specified provider, and returns the updated
    /// CryptoConfiguration object.
    ///
    /// @param contentCryptoProvider
    ///            The provider to be used for crypto content.
    /// @return The updated CryptoConfiguration object.
     CryptoConfiguration withContentCryptoProvider(Provider contentCryptoProvider) {
        this.contentCryptoProvider = contentCryptoProvider;
        return this;
    }

    /// Gets the content crypto provider
    /// 
    /// @return the provider to be used for crypto content.
     Provider getContentCryptoProvider() {
        return this.contentCryptoProvider;
    }

    @override
     CryptoConfiguration clone() {
        CryptoConfiguration config = CryptoConfiguration();
        config.setContentCryptoMode(contentCryptoMode);
        config.setSecureRandom(secureRandom);
        config.setStorageMethod(storageMethod);
        config.setContentCryptoProvider(contentCryptoProvider);
        return config;
    }
}
