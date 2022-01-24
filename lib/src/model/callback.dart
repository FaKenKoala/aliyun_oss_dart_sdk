/// When an upload succeeds, OSS provides the mechanism to send a post message to
/// a callbackurl to trigger some action defined by that callbackurl. The
/// message's method must be Post and the body is the callbackBody's content and
/// it must match the callbackurl's expectation.
///
/// APIs that support callback include PutObject, PstObject,
/// CompleteMultipartUpload.
enum CallbackBodyType {
  /// 1
  URL,

  /// 2
  JSON
}

class Callback {
  ///
  /// Adds a new custom parameter.
  ///
  /// @param key
  ///            Custom key starting with "x:".
  /// @param value
  ///            The value for the custom key.
  ///
  void addCallbackVar(String key, String value) {
    _callbackVar[key] = value;
  }

  bool hasCallbackVar() {
    return _callbackVar.isNotEmpty;
  }

  ///
  /// The callbackUrl after a successful upload
  ///
  /// Sets the callback url---the callbackUrl parameter must be Url encoded. It
  /// supports multiple callback urls (separated by ';'). When multiple
  /// callback urls are specified, OSS will send callback request one by one
  /// until the first successful response. After the callback request is sent,
  /// OSS expects to get "200 OK" response with a JSON body. The body size
  /// should be no more than 3MB.
  ///
  /// @param callbackUrl
  ///            The callback url(s) in url encoding.
  ///
  String? callbackUrl;

  ///
  /// The callback host, only vaid after the callbackUrl is set. If
  /// callbackHost is null, the SDK will extract the host from the callbackUrl.
  ///
  /// Sets the callback host, only valid when callbackUrl is set. If this is
  /// not set, the host will be extracted from the callbackUrl.
  ///
  /// @param callbackHost
  ///            The host of OSS callback.
  ///
  String? callbackHost;

  ///
  /// The callback body in the request.
  ///
  /// Sets the callback body.For example:
  /// key=$(key) &amp; etag=$(etag) &amp; my_var=$(x:my_var). It supports the OSS system
  /// variable, custom defined variable or constant and custom defined
  /// variable's callbackVar.
  ///
  /// @param callbackBody
  ///            OSS callback body.
  ///
  String? callbackBody;

  ///
  /// The content-type header in the request. It supports url or json type and
  /// url is the default.
  ///
  /// The content-type header in OSS's callback request. It supports
  /// application/x-www-form-urlencoded(url) and application/json(json). The
  /// default is the former, which means the variable in callback body will be
  /// url encoded. If it's latter, the variable in callback body will be
  /// formatted (by the SDK) as json's variable.
  /// @param calbackBodyType
  ///            The content-type header in OSS callback request.
  ///
  CallbackBodyType? calbackBodyType;

  ///
  /// The custom parameters
  ///
  final Map<String, String> _callbackVar = <String, String>{};

  Map<String, String> getCallbackVar() {
    return _callbackVar;
  }

  ///
  /// Sets user customized parameter(s).
  /// Customized parameter is a Map&lt;key,value&gt; instance. In the callback
  /// request, OSS would put these parameters into the post body. The keys must
  /// start with "x:", such as x:my_var.
  ///
  /// @param callbackVar
  ///            A {@link Map} instance that stores the &lt;key, value&gt; pairs.
  ///
  set callbackVar(Map<String, String>? callbackVar) {
    _callbackVar.clear();
    if (callbackVar?.isNotEmpty ?? false) {
      _callbackVar.addAll(callbackVar!);
    }
  }
}
