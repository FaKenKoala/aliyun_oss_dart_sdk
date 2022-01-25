class OSSRequest {
  // Flag of explicitly requiring authorization.
  bool isAuthorizationRequired = true;
  // crc64
  CRC64Config crc64 = CRC64Config.$null;
}

enum CRC64Config {
  $null,
  yes,
  no,
}
