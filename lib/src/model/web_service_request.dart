import 'package:aliyun_oss_dart_sdk/src/event/progress_listener.dart';

abstract class WebServiceRequest {
  static final WebServiceRequest noop = _Noop();

  ProgressListener _progressListener = ProgressListener.noop;

  set progressListener(ProgressListener? progressListener) {
    _progressListener = progressListener ?? ProgressListener.noop;
  }

  ProgressListener get progressListener => _progressListener;

  //This flag is used to enable/disable INFO and WARNING logs for requests
  //We enable INFO and WARNING logs by default.
  bool logEnabled = true;

  //If request is set endPoint ,it will overwrite endpoint  set in ossclient
  String? endpoint;

  Map<String, String> parameters = <String, String>{};
  Map<String, String> headers = <String, String>{};

  Set<String> additionalHeaderNames = <String>{};
}

class _Noop extends WebServiceRequest {}
