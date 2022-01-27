import 'oss_ioexception.dart';

class InconsistentException extends OSSIOException {
  String? clientChecksum;
  String? serverChecksum;
  String? requestId;

  InconsistentException(
      this.clientChecksum, this.serverChecksum, this.requestId)
      : super();

  @override
  String toString() {
    return "InconsistentException: inconsistent object\n[RequestId]: $requestId\n[ClientChecksum]: $clientChecksum\n[ServerChecksum]: $serverChecksum";
  }
}
