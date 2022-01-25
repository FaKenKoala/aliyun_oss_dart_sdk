class OSSLog {
  static const String TAG = "OSS-Android-SDK";
  static bool _enableLog = false;

  /// enable log
  static void enableLog() {
    _enableLog = true;
  }

  /// disable log
  static void disableLog() {
    _enableLog = false;
  }

  /// @return return log flag
  static bool isEnableLog() {
    return _enableLog;
  }

  /// info level log
  static void logInfo(String msg, [bool write2local = true]) {
    if (_enableLog) {
      Log.i(TAG, "[INFO]: $msg)");
      log2Local(msg, write2local);
    }
  }

  /// verbose level log
  static void logVerbose(String msg, [bool write2local = true]) {
    if (_enableLog) {
      Log.v(TAG, "[Verbose]: $msg)");
      log2Local(msg, write2local);
    }
  }

  /// warning level log
  static void logWarn(String msg, [bool write2local = true]) {
    if (_enableLog) {
      Log.w(TAG, "[Warn]: $msg)");
      log2Local(msg, write2local);
    }
  }

  /// debug level log
  static void logDebug(String msg,
      {bool write2local = true, String tag = TAG}) {
    if (_enableLog) {
      Log.d(tag, "[Debug]: $msg)");
      log2Local(msg, write2local);
    }
  }

  /// error level log
  ///
  /// @param msg

  static void logError(String msg,
      {String tag = TAG, bool write2local = true}) {
    if (_enableLog) {
      Log.d(tag, "[Error]: $msg)");
      log2Local(msg, write2local);
    }
  }

  static void logThrowable2Local(dynamic exception) {
    if (_enableLog) {
      // OSSLogToFileUtils.getInstance().write(exception);
    }
  }

  static void log2Local(String msg, bool write2local) {
    if (write2local) {
      // OSSLogToFileUtils.getInstance().write(msg);
    }
  }
}

class Log {
  Log._();
  static void i(String tag, String message) {
    print('$tag $message');
  }

  static void d(String tag, String message) {
    print('$tag $message');
  }

  static void w(String tag, String message) {
    print('$tag $message');
  }

  static void v(String tag, String message) {
    print('$tag $message');
  }
}
