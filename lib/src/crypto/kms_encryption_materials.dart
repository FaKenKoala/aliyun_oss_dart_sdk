

import 'dart:collection';

import 'package:aliyun_oss_dart_sdk/src/common/auth/credentials.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/credentials_provider.dart';
import 'package:aliyun_oss_dart_sdk/src/common/auth/sts_assume_role_session_credentials_provider.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/binary_util.dart';
import 'package:cryptography/cryptography.dart';

import 'content_crypto_material_rw.dart';
import 'encryption_materials.dart';
import 'simple_rsa_encryption_materials.dart';

/// This provide a kms encryption materials for client-side encryption.
 class KmsEncryptionMaterials implements EncryptionMaterials {
     static final String KEY_WRAP_ALGORITHM = "KMS/ALICLOUD";
     String region;
     String cmk;
    CredentialsProvider? credentialsProvider;
    
     final Map<String, String> desc;
     final Map<KmsClientSuite, Map<String, String>> _kmsDescMaterials = 
                                    <KmsClientSuite, HashMap<String, String>>{};
    
     KmsEncryptionMaterials(this.region, this.cmk, [final HashMap<String, String>? desc]):
      desc = desc == null ? <String, String> {}: HashMap.from(desc);
    
    

    /// Sets the credentials provider.
     void setKmsCredentialsProvider(CredentialsProvider credentialsProvider) {
        this.credentialsProvider = credentialsProvider;
        _kmsDescMaterials[KmsClientSuite(region, credentialsProvider)] =  desc;
    }

    /// Create a new kms client.
     DefaultAcsClient createKmsClient(String region, CredentialsProvider credentialsPorvider) {
        Credentials credentials = credentialsPorvider.getCredentials();
        IClientProfile profile = DefaultProfile.getProfile(region, credentials.getAccessKeyId(), 
                credentials.getSecretAccessKey(), credentials.getSecurityToken());
        return DefaultAcsClient(profile);
    }

    /// Encrypt the plain text to cipherBlob.
     EncryptResponse encryptPlainText(String keyId, String plainText) {
        DefaultAcsClient kmsClient = createKmsClient(region, credentialsProvider);
        final EncryptRequest encReq = EncryptRequest();
        encReq.setSysProtocol(ProtocolType.HTTPS);
        encReq.setAcceptFormat(FormatType.JSON);
        encReq.setSysMethod(MethodType.POST);
        encReq.setKeyId(keyId);
        encReq.setPlaintext(plainText);

        final EncryptResponse encResponse;
        try {
            encResponse = kmsClient.getAcsResponse(encReq);
        } catch ( e) {
            throw ClientException("the kms client encrypt data failed.$e");
        }
        return encResponse;
    }

    /// Decrypt the cipherBlob to palin text.
     DecryptResponse decryptCipherBlob(KmsClientSuite kmsClientSuite, String cipherBlob) 
           {
        final DefaultAcsClient kmsClient = createKmsClient(kmsClientSuite.region, kmsClientSuite.credentialsProvider);
        final DecryptRequest decReq = DecryptRequest();
        decReq.setSysProtocol(ProtocolType.HTTPS);
        decReq.setAcceptFormat(FormatType.JSON);
        decReq.setSysMethod(MethodType.POST);
        decReq.setCiphertextBlob(cipherBlob);

        final DecryptResponse decResponse;
        try {
            decResponse = kmsClient.getAcsResponse(decReq);
        } catch ( e) {
            throw ClientException("The kms client decrypt data faild.$e");
        }
        return decResponse;
    }

    /// Add other kms region and descrption materials used for decryption.
    /// 
    /// @param region
    ///            region.
    /// @param description
    ///            The descripton of encryption materails.
     void addKmsDescMaterial(String region, Map<String, String> description) {
        addKmsDescMaterial(region, credentialsProvider, description);
    }

    /// Add other kms region credentialsProvider and descrption materials used for decryption.
    /// 
    /// @param region
    ///            region.
    /// @param credentialsProvider
    ///            The credential provider.
    /// @param description
    ///            The descripton of encryption materails.
      void addKmsDescMaterial(String region, CredentialsProvider credentialsProvider, Map<String, String>? description) {
        assertParameterNotNull(region, "region");
        assertParameterNotNull(credentialsProvider, "credentialsProvider");
        KmsClientSuite kmsClientSuite = KmsClientSuite(region, credentialsProvider);
        if (description != null) {
            kmsDescMaterials.put(kmsClientSuite, Map.from(description));
        } else {
            kmsDescMaterials.put(kmsClientSuite, <String, String>{});
        }
    }

    /// Find the specifed cmk region info for decrypting by the specifed descrption.
    /// 
    /// @param desc
    ///            The encryption description.  
    /// @return the specifed region if it was be found, otherwise return null.
     KmsClientSuite findKmsClientSuiteByDescription(Map<String, String> desc) {
        if (desc == null) {
            return null;
        }
        for (Map.Entry<KmsClientSuite, Map<String, String>> entry : kmsDescMaterials.entrySet()) {
            if (desc.equals(entry.getValue())) {
                return entry.getKey();
            }
        }
        return null;
    }

    /// Gets the lastest key-value in the LinedHashMap.
     <K, V> Entry<K, V> getTailByReflection(LinkedHashMap<K, V> map)
            throws NoSuchFieldException, IllegalAccessException {
        Field tail = map.getClass().getDeclaredField("tail");
        tail.setAccessible(true);
        return (Entry<K, V>) tail.get(map);
    }

    /// Encrypt the content encryption key(cek) and iv, and put the result into
    /// {@link ContentCryptoMaterialRW}.
    /// 
    /// @param contentMaterialRW
    ///            The materials that contans all content crypto info, 
    ///            it must be constructed on outside and filled with the iv and cek.
    ///            Then it will be builded with the encrypted cek ,encrypted iv, key wrap algorithm 
    ///            and encryption materials description by this method.
    @override
     void encryptCEK(ContentCryptoMaterialRW contentMaterialRW) {
        try {
            assertParameterNotNull(contentMaterialRW, "contentMaterialRW");
            assertParameterNotNull(contentMaterialRW.iv, "contentMaterialRW#getIV");
            assertParameterNotNull(contentMaterialRW.cek, "contentMaterialRW#getCEK");

            List<int> iv = contentMaterialRW.iv!;
            EncryptResponse encryptresponse = encryptPlainText(cmk, BinaryUtil.toBase64String(iv));
            List<int> encryptedIV = BinaryUtil.fromBase64String(encryptresponse.getCiphertextBlob());

            SecretKey cek = contentMaterialRW.cek!;
            encryptresponse = encryptPlainText(cmk, BinaryUtil.toBase64String(cek.getEncoded()));
            List<int> encryptedCEK = BinaryUtil.fromBase64String(encryptresponse.getCiphertextBlob());

            contentMaterialRW.setEncryptedCEK(encryptedCEK);
            contentMaterialRW.setEncryptedIV(encryptedIV);
            contentMaterialRW.setKeyWrapAlgorithm(KEY_WRAP_ALGORITHM);
            contentMaterialRW.setMaterialsDescription(desc);
        } catch ( e) {
            throw ClientException("Kms encrypt CEK IV error. Please check your cmk, region, accessKeyId and accessSecretId.$e");
        }
    }

    /// Decrypt the encrypted content encryption key(cek) and encrypted iv and put
    /// the result into {@link ContentCryptoMaterialRW}.
    /// 
    /// @param contentMaterialRW
    ///            The materials that contans all content crypto info, 
    ///            it must be constructed on outside and filled with the encrypted cek ,encrypted iv, 
    ///            key wrap algorithm, encryption materials description and cek generator 
    ///            algothrim. Then it will be builded with the cek iv parameters by this method.
    @override
     void decryptCEK(ContentCryptoMaterialRW contentMaterialRW) {
        assertParameterNotNull(contentMaterialRW, "ContentCryptoMaterialRW");
        assertParameterNotNull(contentMaterialRW.getEncryptedCEK(), "ContentCryptoMaterialRW#getEncryptedCEK");
        assertParameterNotNull(contentMaterialRW.getEncryptedIV(), "ContentCryptoMaterialRW#getEncryptedIV");
        assertParameterNotNull(contentMaterialRW.getKeyWrapAlgorithm(), "ContentCryptoMaterialRW#getKeyWrapAlgorithm");

        if (contentMaterialRW.keyWrapAlgorithm?.toLowerCase() != KEY_WRAP_ALGORITHM.toLowerCase()) {
            throw ClientException(
                    "Unrecognize your object key wrap algorithm: ${contentMaterialRW.getKeyWrapAlgorithm()}");
        }

        try {
            KmsClientSuite kmsClientSuite = findKmsClientSuiteByDescription(contentMaterialRW.getMaterialsDescription());
            if (kmsClientSuite == null) {
                Entry<KmsClientSuite, Map<String, String>> entry = getTailByReflection(kmsDescMaterials);
                kmsClientSuite = entry.getKey();
            }

            DecryptResponse decryptIvResp = decryptCipherBlob(kmsClientSuite,
                    BinaryUtil.toBase64String(contentMaterialRW.encryptedIV));
            List<int> iv = BinaryUtil.fromBase64String(decryptIvResp.getPlaintext());

            DecryptResponse decryptCEKResp = decryptCipherBlob(kmsClientSuite,
                    BinaryUtil.toBase64String(contentMaterialRW.getEncryptedCEK()));
            List<int> cekBytes = BinaryUtil.fromBase64String(decryptCEKResp.getPlaintext());
            SecretKey cek = SecretKeySpec(cekBytes, "");

            contentMaterialRW.cek = (cek);
            contentMaterialRW.iv = (iv);
        } catch ( e) {
            throw ClientException("Unable to decrypt content secured key and iv. Please check your kms region and materails description.$e");
        }
    }

     void assertParameterNotNull(Object? parameterValue, String errorMessage) {
        if (parameterValue == null) {
          throw ArgumentError(errorMessage);
        }
    }
}

  class KmsClientSuite {
         String region;
         CredentialsProvider credentialsProvider;
        KmsClientSuite(this.region, this.credentialsProvider) ;
    }