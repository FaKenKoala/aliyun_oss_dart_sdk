/// <p>
/// This exception indicates the checksum returned from Server side is not same
/// as the one calculated from client side.
/// </p>
///
///
/// <p>
/// Generally speaking, the caller needs to handle the
/// {@link InconsistentException}, because it means the data uploaded or
/// downloaded is not same as its source. Re-upload or re-download is needed to
/// correct the data.
/// </p>
///
/// <p>
/// Operations that could throw this exception include putObject, appendObject,
/// uploadPart, uploadFile, getObject, etc.
/// </p>
///
class InconsistentException implements Exception {
  int clientChecksum;
  int serverChecksum;
  String requestId;

  InconsistentException(
      this.clientChecksum, this.serverChecksum, this.requestId);

  String getMessage() {
    return "InconsistentException \n[RequestId]: $requestId\n[ClientChecksum]: $clientChecksum\n[ServerChecksum]: $serverChecksum";
  }
}
