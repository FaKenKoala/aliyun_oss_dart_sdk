class SdkRuntime {
  /// Returns true if the current operation should abort; false otherwise. Note the
  /// interrupted status of the thread is cleared by this method.
  ///
  static bool shouldAbort() {
    // return Thread.interrupted();
    return true;
  }
}
