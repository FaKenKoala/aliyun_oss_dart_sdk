import 'package:aliyun_oss_dart_sdk/src/common/lib_common.dart';

class VersionInfoUtils {
  static String? userAgent;

  /*
     * UA sample : aliyun-sdk-java/2.0.5(Windows 7/6.1/amd64;1.7.0_55)/oss-import
     */
  static String getUserAgent(String? customInfo) {
    if (customInfo.nullOrEmpty) {
      userAgent = "aliyun-sdk-dart/" + getVersion() + getSystemInfo();
    }

    if (customInfo.nullOrEmpty) {
      return userAgent!;
    } else {
      return "$userAgent/$customInfo";
    }
  }

  static String getVersion() {
    return OSSConstants.sdkVersion;
  }

  /// 获取系统+用户自定义的UA值,添加至最后位置
  static String getSystemInfo() {
    StringBuffer customUA = StringBuffer();
    DeviceInfo deviceInfo = DeviceInfo();
    customUA.write("(");
    customUA.write(deviceInfo.osName);
    customUA.write(deviceInfo.version);
    customUA.write("/");
    //build may has chinese
    customUA.write(HttpUtil.urlEncode(deviceInfo.model) +
        ";" +
        HttpUtil.urlEncode(deviceInfo.model));
    customUA.write(")");
    String ua = customUA.toString();
    OSSLog.logDebug("user agent : " + ua);

    if (ua.nullOrEmpty) {
      String propertyUA = deviceInfo.httpAgent;
      ua = propertyUA.replaceAll("[^\\p{ASCII}]", "?");
    }
    return ua;
  }
}

class DeviceInfo {
  final String osName;
  final String version;
  final String model;
  final String id;
  final String httpAgent;

  DeviceInfo(
      [this.osName = '',
      this.version = '/Android',
      this.model = '',
      this.id = '',
      this.httpAgent = '']);
}
