import 'package:crypto/crypto.dart';

import 'hmac_sha1_signature.dart';

/// The interface to compute the signature of the data.
abstract class ServiceSignature {
  /// Gets the algorithm of signature.
  ///
  /// @return The algorithm of the signature.
  Hash getAlgorithm();

  /// Computes the signature of the data by the given key.
  ///
  /// @param key
  ///            The key for the signature.
  /// @param data
  ///            The data to compute the signature on.
  /// @return The signature in string.
  String computeSignature(String key, String data);

  ///
  /// Creates the default <code>ServiceSignature</code> instance which is
  /// {@link HmacSHA1Signature}.
  ///
  /// @return The default <code>ServiceSignature</code> instance
  static ServiceSignature create() {
    return HmacSHA1Signature();
  }

  List<int> sign(List<int> key, List<int> data, Hash algorithm) {
    try {
      List<int> signData = Hmac(algorithm, key).convert(data).bytes;
      return signData;
    } catch (ex) {
      rethrow;
    }
  }
}
