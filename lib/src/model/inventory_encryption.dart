import '../client_exception.dart';
import 'inventory_server_side_encryption_kms.dart';
import 'inventory_server_side_encryption_oss.dart';

class InventoryEncryption {
  /// Server side encryption by kms.
  /// Note: Only one encryption method between KMS and OSS can be chosen.
  InventoryServerSideEncryptionKMS? _serverSideKmsEncryption;
  InventoryServerSideEncryptionKMS? get serverSideKmsEncryption =>
      _serverSideKmsEncryption;

  /// Sets the server side kms encryption.
  /// Note: Only one encryption method between KMS and OSS can be chosen.
  set serverSideKmsEncryption(
      InventoryServerSideEncryptionKMS? kmsServerSideEncryption) {
    if (_serverSideOssEncryption != null) {
      throw ClientException(
          "The KMS and OSS encryption only one of them can be specified.");
    }
    _serverSideKmsEncryption = kmsServerSideEncryption;
  }

  /// Server side encryption by oss.
  /// Note: Only one encryption method between KMS and OSS can be chosen.
  InventoryServerSideEncryptionOSS? _serverSideOssEncryption;

  InventoryServerSideEncryptionOSS? get serverSideOssEncryption {
    return _serverSideOssEncryption;
  }

  /// Sets the server side oss encryption.
  /// Note: Only one encryption method between KMS and OSS can be chosen.
  set serverSideOssEncryption(
      InventoryServerSideEncryptionOSS? ossServerSideEncryption) {
    if (_serverSideKmsEncryption != null) {
      throw ClientException(
          "The KMS and OSS encryption only one of them can be specified.");
    }
    _serverSideOssEncryption = ossServerSideEncryption;
  }
}
