
enum PushFlowStatus {
  disabled,
  idle,
  live,
}

extension PushFlowStatusX on PushFlowStatus {
  String get customName {
    switch (this) {
      case PushFlowStatus.idle:
        return "Idle";
      case PushFlowStatus.live:
        return "Live";
      case PushFlowStatus.disabled:
      default:
        return "Disabled";
    }
  }

  static PushFlowStatus parse(String statusString) {
    for (PushFlowStatus status in PushFlowStatus.values) {
      if (status.customName == statusString) {
        return status;
      }
    }

    throw ArgumentError(
        "Unable to parse the provided push flow status $statusString");
  }
}
