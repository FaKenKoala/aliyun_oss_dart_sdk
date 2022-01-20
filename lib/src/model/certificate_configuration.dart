class CertificateConfiguration {
  /// Certificate  key, PEM format

  String? publicKey;

  /// Certificate  key, PEM format

  String? privateKey;

  /// Certificate ID in CAS

  String? id;

  /// If enabled, OSS will not check the previous certificate ID.

  bool? forceOverwriteCert;

  /// Previous certificate ID.

  String? previousId;
}
