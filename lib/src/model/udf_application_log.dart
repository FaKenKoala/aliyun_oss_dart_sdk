import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

import 'generic_result.dart';

/// The result class represents the UDF Application Log's content. It must be
/// closed after the usage.
class UdfApplicationLog extends GenericResult {
  UdfApplicationLog([
    String? udfName,
    InputStream? logContent,
  ]);

  String? udfName;
  InputStream? logContent;

  void close() {
    logContent?.close();
  }

  /// Forcefully close the object. The remaining data in server side is
  /// ignored.
  void forcedClose() {
    response?.abort();
  }
}
