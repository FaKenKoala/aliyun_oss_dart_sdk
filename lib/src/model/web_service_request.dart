abstract class WebServiceRequest {
  static final WebServiceRequest noop = _Noop();

  ProgressListener _progressListener = ProgressListener.NOOP;

  set progressListener(ProgressListener? progressListener) {
    this.progressListener = progressListener ?? ProgressListener.NOOP;
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
