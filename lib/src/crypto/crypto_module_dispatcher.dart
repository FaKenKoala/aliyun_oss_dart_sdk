
import 'crypto_configuration.dart';
import 'crypto_module.dart';
import 'crypto_module_aes_ctr.dart';
import 'encryption_materials.dart';
import 'oss_direct.dart';

/// A proxy cryptographic module used to dispatch method calls to the appropriate
/// underlying cryptographic module depending on the current configuration.
 class CryptoModuleDispatcher implements CryptoModule {
     final CryptoModuleAesCtr cryptoMouble;
     CryptoModuleDispatcher(OSSDirect ossDirect,
                                  EncryptionMaterials encryptionMaterials,
                                  CryptoConfiguration cryptoConfig) {
        cryptoConfig = cryptoConfig.clone(); 
        cryptoMouble = CryptoModuleAesCtr(ossDirect,
                                   encryptionMaterials, cryptoConfig);
    }

    @override
     PutObjectResult putObjectSecurely(PutObjectRequest putObjectRequest) {
        return cryptoMouble.putObjectSecurely(putObjectRequest);
    }

    @override
     OSSObject getObjectSecurely(GetObjectRequest req) {
        return cryptoMouble.getObjectSecurely(req);
    }

    @override
     ObjectMetadata getObjectSecurely(GetObjectRequest req, File file) {
        return cryptoMouble.getObjectSecurely(req, file);
    }

    @override
     InitiateMultipartUploadResult initiateMultipartUploadSecurely(InitiateMultipartUploadRequest request,
            MultipartUploadCryptoContext context) {
        return cryptoMouble.initiateMultipartUploadSecurely(request, context);
    }

    @override
     UploadPartResult uploadPartSecurely(UploadPartRequest request, MultipartUploadCryptoContext context) {
        return cryptoMouble.uploadPartSecurely(request, context);
    }

}
