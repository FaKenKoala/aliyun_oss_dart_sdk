import 'package:aliyun_oss_dart_sdk/src/common/oss_constants.dart';

import 'oss_utils.dart';

class VersionInfoUtils {
  static String? userAgent;

  /*
     * UA sample : aliyun-sdk-java/2.0.5(Windows 7/6.1/amd64;1.7.0_55)/oss-import
     */
  static String getUserAgent(String customInfo) {
    if (OSSUtils.isEmptyString(userAgent)) {
      userAgent = "aliyun-sdk-android/" + getVersion() + getSystemInfo();
    }

    if (OSSUtils.isEmptyString(customInfo)) {
      return userAgent;
    } else {
      return userAgent + "/" + customInfo;
    }
  }

  static String getVersion() {
    return OSSConstants.sdkVersion;
  }

  /// 获取系统+用户自定义的UA值,添加至最后位置
  static String getSystemInfo() {
    StringBuffer customUA = StringBuffer();
    customUA.write("(");
    customUA.write(System.getProperty("os.name"));
    customUA.write("/Android " + Build.VERSION.RELEASE);
    customUA.write("/");
    //build may has chinese
    customUA.write(
        HttpUtil.urlEncode(Build.MODEL, OSSConstants.defaultCharsetName) +
            ";" +
            HttpUtil.urlEncode(Build.ID, OSSConstants.defaultCharsetName));
    customUA.write(")");
    String ua = customUA.toString();
    OSSLog.logDebug("user agent : " + ua);
    if (OSSUtils.isEmptyString(ua)) {
      String propertyUA = System.getProperty("http.agent");
      ua = propertyUA.replaceAll("[^\\p{ASCII}]", "?");
    }
    return ua;
  }
}
