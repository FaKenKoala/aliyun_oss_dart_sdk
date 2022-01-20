import 'dart:io';

import 'package:aliyun_oss_dart_sdk/src/common/utils/log_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

/// Utility class used to determine the mimetype of files based on file
/// extensions.
 class MimeType {

    /* The default MIME type */
     static final String defaultMimeType = "application/octet-stream";

     static MimeType? mimeType;

     Map<String, String> extensionToMimetypeMap = <String, String>{};

 static MimeType getInstance() {
        if (mimeType != null) {
          return mimeType!;
        }

        mimeType =  MimeType();
        InputStream? inputStream = mimeType.getClass().getResourceAsStream("/oss.mime.types");
        if (inputStream != null) {
            LogUtils.getLog().debug("Loading mime types from file in the classpath: oss.mime.types");

            try {
                mimeType.loadMimetypes(inputStream);
            } catch ( e) {
                LogUtils.getLog().error("Failed to load mime types from file in the classpath: oss.mime.types", e);
            } finally {
                try {
                    inputStream.close();
                } catch (ignored) {
                }
            }
        } else {
            LogUtils.getLog().warn("Unable to find 'oss.mime.types' file in classpath");
        }
        return mimeType;
    }

     void loadMimetypes(InputStream inpuStream) {
        BufferedReader br =  BufferedReader(new InputStreamReader(is));
        String? line;

        while ((line = br.readLine()) != null) {
            line = line!.trim();

            if (line.startsWith("#") || line.isEmpty) {
                // Ignore comments and empty lines.
            } else {
                StringTokenizer st = new StringTokenizer(line, " \t");
                if (st.countTokens() > 1) {
                    String extension = st.nextToken();
                    if (st.hasMoreTokens()) {
                        String mimetype = st.nextToken();
                        extensionToMimetypeMap[extension.toLowerCase()] = mimetype;
                    }
                }
            }
        }
    }

     String getMimetype(String fileName) {
        String? mimeType = getMimetypeByExt(fileName);
        if (mimeType != null) {
            return mimeType;
        }
        return defaultMimeType;
    }

     String? getMimetype(File file) {
        return getMimetype(file.getName());
    }

     String? getMimetype(File file, String key) {
        return getMimetype(file.getName(), key);
    }

     String? getMimetype(String primaryObject, String secondaryObject) {
        String? mimeType = getMimetypeByExt(primaryObject);
        if (mimeType != null) {
            return mimeType;
        }

        mimeType = getMimetypeByExt(secondaryObject);
        if (mimeType != null) {
            return mimeType;
        }

        return defaultMimeType;
    }

     String? getMimetypeByExt(String fileName) {
        int lastPeriodIndex = fileName.lastIndexOf(".");
        if (lastPeriodIndex > 0 && lastPeriodIndex + 1 < fileName.length) {
            String ext = fileName.substring(lastPeriodIndex + 1).toLowerCase();
            if (extensionToMimetypeMap.containsKey(ext)) {
                return extensionToMimetypeMap[ext];
            }
        }
        return null;
    }
}
