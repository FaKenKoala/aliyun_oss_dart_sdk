enum LiveChannelStatus {
  enabled,
  disabled,
}

extension LiveChannelStatusX on LiveChannelStatus {
  static LiveChannelStatus parse(String liveChannelStatus) {
    for (LiveChannelStatus status in LiveChannelStatus.values) {
      if (status.name == liveChannelStatus) {
        return status;
      }
    }

    throw ArgumentError(
        "Unable to parse the provided live channel status $liveChannelStatus");
  }
}
