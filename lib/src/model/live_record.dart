class LiveRecord {
  LiveRecord({
    this.startDate,
    this.endDate,
    this.remoteAddress,
  });

  // The start time of the pushing streaming.
  DateTime? startDate;
  // The end time of the pushing streaming.
  DateTime? endDate;
  // The pushing streaming's client address---from where the streaming is
  // pushed.
  String? remoteAddress;
}
