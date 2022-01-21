abstract class CryptoHeaders {
  static String CRYPTO_KEY = "client-side-encryption-key";
  static String CRYPTO_IV = "client-side-encryption-start";
  static String CRYPTO_CEK_ALG = "client-side-encryption-cek-alg";
  static String CRYPTO_WRAP_ALG = "client-side-encryption-wrap-alg";
  static String CRYPTO_MATDESC = "client-side-encryption-matdesc";
  static String CRYPTO_DATA_SIZE = "client-side-encryption-data-size";
  static String CRYPTO_PART_SIZE = "client-side-encryption-part-size";
  static String CRYPTO_UNENCRYPTION_CONTENT_LENGTH =
      "client-side-encryption-unencrypted-content-length";
  static String CRYPTO_UNENCRYPTION_CONTENT_MD5 =
      "client-side-encryption-unencrypted-content-md5";
}
