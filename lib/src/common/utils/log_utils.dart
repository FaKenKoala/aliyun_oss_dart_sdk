import 'package:aliyun_oss_dart_sdk/src/oss_error_code.dart';
import 'package:aliyun_oss_dart_sdk/src/service_exception.dart';

class LogUtils {
  static final Log log = Log(); //LogFactory.getLog(LOGGER_PACKAGE_NAME);

  // Set logger level to INFO specially if reponse error code is 404 in order
  // to
  // prevent from dumping a flood of logs when trying access to none-existent
  // resources.
  static List<String> errorCodeFilterList = [
    OSSErrorCode.NO_SUCH_BUCKET,
    OSSErrorCode.NO_SUCH_KEY,
    OSSErrorCode.NO_SUCH_UPLOAD,
    OSSErrorCode.NO_SUCH_CORS_CONFIGURATION,
    OSSErrorCode.NO_SUCH_WEBSITE_CONFIGURATION,
    OSSErrorCode.NO_SUCH_LIFECYCLE,
  ];

  static Log getLog() {
    return log;
  }

  static void logException<ExType>(String messagePrefix, ExType ex,
      [bool logEnabled = true]) {
    assert(ex is Exception);

    String detailMessage = messagePrefix + (ex as Exception).toString();
    if (ex is ServiceException && errorCodeFilterList.contains(ex.errorCode)) {
      if (logEnabled) {
        log.debug(detailMessage);
      }
    } else {
      if (logEnabled) {
        log.warn(detailMessage);
      }
    }
  }
}

/// TODO: log implementation
class Log {
  void debug(dynamic) {}
  void warn(dynamic) {}
  void error(dynamic) {}
}
