class HttpUtil {
  /// Encode a URL segment with special chars replaced.
  static String urlEncode(String? value) {
    if (value == null) {
      return "";
    }

    try {
      String encoded = Uri.encodeComponent(value);
      return encoded
          .replaceAll("+", "%20")
          .replaceAll("*", "%2A")
          .replaceAll("%7E", "~")
          .replaceAll("%2F", "/");
    } catch (e) {
      throw ArgumentError("failed to encode url! $e");
    }
  }

  /// Encode request parameters to URL segment.
  static String? paramToQueryString(Map<String, String?>? params) {
    if (params == null || params.isEmpty) {
      return null;
    }

    StringBuffer paramString = StringBuffer();
    bool first = true;

    params.forEach((key, value) {
      if (!first) {
        paramString.write("&");
      }

      // Urlencode each request parameter
      paramString.write(urlEncode(key));
      if (value != null) {
        paramString
          ..write("=")
          ..write(urlEncode(value));
      }

      first = false;
    });

    return paramString.toString();
  }
}
