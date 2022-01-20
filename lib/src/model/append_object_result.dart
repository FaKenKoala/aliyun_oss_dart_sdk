import 'generic_result.dart';

/// Successful response of append object operation.
class AppendObjectResult extends GenericResult {
  /* Indicates that which position to append at next time. */
  int? nextPosition;

  /* Returned value of the appended object crc64 */
  String? objectCRC;
}
