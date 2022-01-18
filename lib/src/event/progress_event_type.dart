enum ProgressEventType {
  /// Event of the content length to be sent in a request.
  requestContentLengthEvent,

  /// Event of the content length received in a response.
  responseContentLengthEvent,

  /// Used to indicate the number of bytes to be sent to OSS.
  requestByteTransferEvent,

  /// Used to indicate the number of bytes received from OSS.
  responseByteTransferEvent,

  /// Transfer events.
  transferPreparingEvent,
  transferStartedEvent,
  transferCompletedEvent,
  transferFailedEvent,
  transferCanceledEvent,
  transferPartStartedEvent,
  transferPartCompletedEvent,
  transferPartFailedEvent,

  /// Select object events.
  selectStartedEvent,
  selectScanEvent,
  selectCompletedEvent,
  selectFailedEvent
}
