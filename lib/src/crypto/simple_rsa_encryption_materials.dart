
/**
 * This provide a simple rsa encryption materials for client-side encryption.
 */
 class SimpleRSAEncryptionMaterials implements EncryptionMaterials {
    // Enable bouncy castle provider
    static {
        CryptoRuntime.enableBouncyCastle();
    }
     static final String KEY_WRAP_ALGORITHM = "RSA/NONE/PKCS1Padding";
     KeyPair keyPair;
     Map<String, String> desc;
     final LinkedHashMap<KeyPair, Map<String, String>> keyPairDescMaterials = 
                                    new LinkedHashMap<KeyPair, Map<String, String>>();

     SimpleRSAEncryptionMaterials(KeyPair keyPair) {
        assertParameterNotNull(keyPair, "KeyPair");
        this.keyPair = keyPair;
        desc = <String, String>{};
        keyPairDescMaterials.put(keyPair, desc);
    }

     SimpleRSAEncryptionMaterials(KeyPair keyPair, Map<String, String> desc) {
        assertParameterNotNull(keyPair, "KeyPair");
        this.keyPair = keyPair;
        this.desc = (desc == null) ? <String, String>{} : new HashMap<String, String>(desc);
        keyPairDescMaterials.put(keyPair, desc);
    }

    /**
     * Add a key pair and its descrption for decrypting data.
     * 
     * @param keyPair
     *            The RSA key pair.
     * @param description
     *            The descripton of encryption materails.
     */
     synchronized void addKeyPairDescMaterial(KeyPair keyPair, Map<String, String> description) {
        assertParameterNotNull(keyPair, "keyPair");
        if (description != null) {
            keyPairDescMaterials.put(keyPair, new HashMap<String, String>(description));
        } else {
            keyPairDescMaterials.put(keyPair, <String, String>{});
        }
    }

    /**
     * Find the specifed key pair for decrypting by the specifed descrption.
     * 
     * @param desc
     *            The encryption description.  
     * @return the lastest specifed key pair that matchs the descrption, otherwise return null.
     */
     KeyPair findKeyPairByDescription(Map<String, String> desc) {
        if (desc == null) {
            return null;
        }
        for (Map.Entry<KeyPair, Map<String, String>> entry : keyPairDescMaterials.entrySet()) {
            if (desc.equals(entry.getValue())) {
                return entry.getKey();
            }
        }
        return null;
    }

    /**
     * Gets the lastest key-value in the LinedHashMap.
     */
     <K, V> Entry<K, V> getTailByReflection(LinkedHashMap<K, V> map)
            throws NoSuchFieldException, IllegalAccessException {
        Field tail = map.getClass().getDeclaredField("tail");
        tail.setAccessible(true);
        return (Entry<K, V>) tail.get(map);
    }

    /**
     * Encrypt the content encryption key(cek) and iv, and put the result into
     * {@link ContentCryptoMaterialRW}.
     * 
     * @param contentMaterialRW
     *            The materials that contans all content crypto info, 
     *            it must be constructed on outside and filled with the iv cek parameters.
     *            Then it will be builed with the encrypted cek ,encrypted iv, key wrap 
     *            algorithm and encryption materials description by this method.
     */
    @override
     void encryptCEK(ContentCryptoMaterialRW contentMaterialRW) {
        assertParameterNotNull(contentMaterialRW, "ContentCryptoMaterialRW");
        assertParameterNotNull(contentMaterialRW.getCEK(), "ContentCryptoMaterialRW#getCEK()");
        assertParameterNotNull(contentMaterialRW.getIV(), "ContentCryptoMaterialRW#getIV()");
        try {
            Key key = keyPair.get();
            Cipher cipher = Cipher.getInstance(KEY_WRAP_ALGORITHM);
            cipher.init(Cipher.ENCRYPT_MODE, key, new SecureRandom());
            byte[] encryptedCEK = cipher.doFinal(contentMaterialRW.getCEK().getEncoded());
            byte[] encryptedIV = cipher.doFinal(contentMaterialRW.getIV());

            contentMaterialRW.setEncryptedCEK(encryptedCEK);
            contentMaterialRW.setEncryptedIV(encryptedIV);
            contentMaterialRW.setKeyWrapAlgorithm(KEY_WRAP_ALGORITHM);
            contentMaterialRW.setMaterialsDescription(desc);
        } catch (Exception e) {
            throw new ClientException("Unable to encrypt content encryption key or iv." + e.getMessage(), e);
        }
    }

    /**
     * Decrypt the encrypted content encryption key(cek) and encrypted iv and put
     * the result into {@link ContentCryptoMaterialRW}.
     * 
     * @param contentMaterialRW 
     *                 The materials that contans all content crypto info,
     *                 it must be constructed on outside and filled with
     *                 the encrypted cek ,encrypted iv, key wrap algorithm,
     *                 encryption materials description and cek generator
     *                 algothrim. Then it will be builded with the cek and iv.
     */
    @override
     void decryptCEK(ContentCryptoMaterialRW contentMaterialRW) {
        assertParameterNotNull(contentMaterialRW, "ContentCryptoMaterialRW");
        assertParameterNotNull(contentMaterialRW.getEncryptedCEK(), "ContentCryptoMaterialRW#getEncryptedCEK");
        assertParameterNotNull(contentMaterialRW.getEncryptedIV(), "ContentCryptoMaterialRW#getEncryptedIV");
        assertParameterNotNull(contentMaterialRW.getKeyWrapAlgorithm(), "ContentCryptoMaterialRW#getKeyWrapAlgorithm");

        if (!contentMaterialRW.getKeyWrapAlgorithm().toLowerCase().equals(KEY_WRAP_ALGORITHM.toLowerCase())) {
            throw new ClientException(
                    "Unrecognize your object key wrap algorithm: " + contentMaterialRW.getKeyWrapAlgorithm());
        }

        try {
            KeyPair keyPair = findKeyPairByDescription(contentMaterialRW.getMaterialsDescription());
            if (keyPair == null) {
                Entry<KeyPair, Map<String, String>> entry = getTailByReflection(keyPairDescMaterials);
                keyPair = entry.getKey();
            }

            Key key = keyPair.get();
            Cipher cipher = Cipher.getInstance(KEY_WRAP_ALGORITHM);
            cipher.init(Cipher.DECRYPT_MODE, key);
            byte[] cekBytes = cipher.doFinal(contentMaterialRW.getEncryptedCEK());
            byte[] iv = cipher.doFinal(contentMaterialRW.getEncryptedIV());
            SecretKey cek = new SecretKeySpec(cekBytes, "");

            contentMaterialRW.setCEK(cek);
            contentMaterialRW.setIV(iv);
        } catch (Exception e) {
            throw new ClientException("Unable to decrypt the secured content key and iv. " + e.getMessage(), e);
        }
    }

    /**
     * Gets a rsa  key from PKCS1 pem string.
     * 
     * @return a new rsa  key
     */
     static RSAKey getKeyFromPemPKCS1(final String KeyStr) {
        try {
            String adjustStr = StringUtils.replace(KeyStr, "-----BEGIN  KEY-----", "");
            adjustStr = StringUtils.replace(adjustStr, "-----BEGIN RSA  KEY-----", "");
            adjustStr = StringUtils.replace(adjustStr, "-----END  KEY-----", "");
            adjustStr = StringUtils.replace(adjustStr, "-----END RSA  KEY-----", "");
            adjustStr = adjustStr.replace("\n", "");

            CryptoRuntime.enableBouncyCastle();

            byte[] buffer = BinaryUtil.fromBase64String(adjustStr);
            RSAKeySpec keySpec = CryptoRuntime.convertPemPKCS1ToKey(buffer);

            KeyFactory keyFactory = KeyFactory.getInstance("RSA");

            return (RSAKey) keyFactory.generate(keySpec);

        } catch (Exception e) {
            throw new ClientException("get  key from PKCS1 pem String error." + e.getMessage(), e);
        }
    }

    /**
     * Gets a rsa  key from PKCS8 pem string.
     * 
     * @return a new rsa  key
     */
     static RSAKey getKeyFromPemPKCS8(final String KeyStr) {
        try {
            String adjustStr = StringUtils.replace(KeyStr, "-----BEGIN  KEY-----", "");
            adjustStr = StringUtils.replace(adjustStr, "-----BEGIN RSA  KEY-----", "");
            adjustStr = StringUtils.replace(adjustStr, "-----END  KEY-----", "");
            adjustStr = StringUtils.replace(adjustStr, "-----END RSA  KEY-----", "");
            adjustStr = adjustStr.replace("\n", "");

            byte[] buffer = BinaryUtil.fromBase64String(adjustStr);
            PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(buffer);
            KeyFactory keyFactory = KeyFactory.getInstance("RSA");

            return (RSAKey) keyFactory.generate(keySpec);
        } catch (Exception e) {
            throw new ClientException("Get  key from PKCS8 pem String error: " + e.getMessage(), e);
        }
    }

    /**
     * Gets a rsa  key from PKCS8 pem string.
     * 
     * @return a new rsa  key
     */
     static RSAKey getKeyFromPemX509(final String KeyStr) {
        try {
            String adjustStr = StringUtils.replace(KeyStr, "-----BEGIN  KEY-----", "");
            adjustStr = StringUtils.replace(adjustStr, "-----BEGIN RSA  KEY-----", "");
            adjustStr = StringUtils.replace(adjustStr, "-----END  KEY-----", "");
            adjustStr = StringUtils.replace(adjustStr, "-----END RSA  KEY-----", "");
            adjustStr = adjustStr.replace("\n", "");

            byte[] buffer = BinaryUtil.fromBase64String(adjustStr);
            KeyFactory keyFactory = KeyFactory.getInstance("RSA");
            X509EncodedKeySpec keySpec = new X509EncodedKeySpec(buffer);

            return (RSAKey) keyFactory.generate(keySpec);
        } catch (Exception e) {
            throw new ClientException("Get  key from X509 pem String error." + e.getMessage(), e);
        }
    }

     void assertParameterNotNull(Object parameterValue, String errorMessage) {
        if (parameterValue == null)
            throw ArgumentError(errorMessage);
    }
}
