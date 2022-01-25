enum ProgressEventType {
  /// Event of the content length to be sent in a request.
  REQUEST_CONTENT_LENGTH_EVENT,

  /// Event of the content length received in a response.
  RESPONSE_CONTENT_LENGTH_EVENT,

  /// Used to indicate the number of bytes to be sent to OSS.
  REQUEST_BYTE_TRANSFER_EVENT,

  /// Used to indicate the number of bytes received from OSS.
  RESPONSE_BYTE_TRANSFER_EVENT,

  /// Transfer events.
  TRANSFER_PREPARING_EVENT,
  TRANSFER_STARTED_EVENT,
  TRANSFER_COMPLETED_EVENT,
  TRANSFER_FAILED_EVENT,
  TRANSFER_CANCELED_EVENT,
  TRANSFER_PART_STARTED_EVENT,
  TRANSFER_PART_COMPLETED_EVENT,
  TRANSFER_PART_FAILED_EVENT,

  /// Select object events.
  SELECT_STARTED_EVENT,
  SELECT_SCAN_EVENT,
  SELECT_COMPLETED_EVENT,
  SELECT_FAILED_EVENT
}
