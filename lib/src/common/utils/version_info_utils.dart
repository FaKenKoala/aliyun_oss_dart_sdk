
 import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

import 'log_utils.dart';

class VersionInfoUtils {

     static final String VERSION_INFO_FILE = "versioninfo.properties";
     static final String USER_AGENT_PREFIX = "aliyun-sdk-java";

     static String? version;

     static String? defaultUserAgent;

     static String getVersion() {
        if (version == null) {
            initializeVersion();
        }
        return version!;
    }

     static String getDefaultUserAgent() {
        if (defaultUserAgent == null) {
            defaultUserAgent = USER_AGENT_PREFIX + "/" + getVersion() + "(" + System.getProperty("os.name") + "/"
                    + System.getProperty("os.version") + "/" + System.getProperty("os.arch") + ";"
                    + System.getProperty("java.version") + ")";
        }
        return defaultUserAgent;
    }

     static void initializeVersion() {
        InputStream? inputStream = VersionInfoUtils.class.getClassLoader().getResourceAsStream(VERSION_INFO_FILE);
        Properties versionInfoProperties =  Properties();
        try {
            if (inputStream == null) {
                throw ArgumentError(VERSION_INFO_FILE + " not found on classpath");
            }

            versionInfoProperties.load(inputStream);
            version = versionInfoProperties.getProperty("version");
        } catch (e) {
            LogUtils.logException("Unable to load version information for the running SDK: ", e);
            version = "unknown-version";
        }
    }
}
