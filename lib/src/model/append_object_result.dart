import 'oss_result.dart';

/// Successful response of append object operation.
class AppendObjectResult extends OSSResult {
  /* Indicates that which position to append at next time. */
  int nextPosition = -1;

  /* Returned value of the appended object crc64 */
  String? objectCRC64;
}
