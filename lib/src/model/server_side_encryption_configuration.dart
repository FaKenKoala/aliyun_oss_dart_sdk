import 'server_side_encryption_by_default.dart';

/// Container for server-side encryption configuration rules. Currently OSS supports one rule only.
class ServerSideEncryptionConfiguration {
  ServerSideEncryptionByDefault? applyServerSideEncryptionByDefault;
}
