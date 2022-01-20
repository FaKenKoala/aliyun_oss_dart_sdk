import 'dart:io';

class SelectObjectException extends IOException {
  static final String INVALID_INPUT_STREAM = "InvalidInputStream";
  static final String INVALID_CRC = "InvalidCRC";
  static final String INVALID_SELECT_VERSION = "InvalidSelectVersion";
  static final String INVALID_SELECT_FRAME = "InvalidSelectFrame";

  final String message;

  final String errorCode;
  final String requestId;

  SelectObjectException(this.errorCode, this.message, this.requestId);

  @override
  String toString() {
    return "[Message]: $message\n[ErrorCode]: $errorCode\n[RequestId]: $requestId";
  }
}
