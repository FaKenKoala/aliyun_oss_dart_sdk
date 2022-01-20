enum AsyncFetchTaskState {
  Running,
  Retry,
  FetchSuccessCallbackFailed,
  Failed,
  Success,
}

extension AsyncFetchTaskStateX on AsyncFetchTaskState {
  static AsyncFetchTaskState parse(String stateString) {
    for (AsyncFetchTaskState o in AsyncFetchTaskState.values) {
      if (o.name == stateString) {
        return o;
      }
    }

    throw ArgumentError("Unable to parse AsyncFetchTaskState: " + stateString);
  }
}
