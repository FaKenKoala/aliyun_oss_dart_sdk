import 'coding_utils.dart';

class HttpUtil {
  /// Encode a URL segment with special chars replaceAlld.
  static String urlEncode(String value, String encoding) {
    if (value == null) {
      return "";
    }

    try {
      String encoded =
          Uri.encodeFull(value); //URLEncoder.encode(value, encoding);
      return encoded
          .replaceAll("+", "%20")
          .replaceAll("*", "%2A")
          .replaceAll("~", "%7E")
          .replaceAll("/", "%2F");
    } catch (e) {
      throw ArgumentError(
          OSS_RESOURCE_MANAGER.getString("FailedToEncodeUri"), e);
    }
  }

  static String urlDecode(String value, String encoding) {
    if (CodingUtils.isNullOrEmpty(value)) {
      return value;
    }

    try {
      return Uri.decodeFull(value); //URLDecoder.decode(value, encoding);
    } catch (e) {
      throw ArgumentError(
          OSS_RESOURCE_MANAGER.getString("FailedToDecodeUrl"), e);
    }
  }

  /// Encode request parameters to URL segment.
  static String? paramToQueryString(
      Map<String, String>? params, String charset) {
    if (params?.isEmpty ?? true) {
      return null;
    }

    StringBuffer paramString = StringBuffer();
    bool first = true;

    params!.forEach((key, value) {
      if (!first) {
        paramString.write("&");
      }

      // Urlencode each request parameter
      paramString.write(urlEncode(key, charset));
      if (value != null) {
        paramString
          ..write("=")
          ..write(urlEncode(value, charset));
      }

      first = false;
    });

    return paramString.toString();
  }

  static final String ISO_8859_1_CHARSET = "iso-8859-1";
  static final String UTF8_CHARSET = "utf-8";

  // To fix the bug that the header value could not be unicode chars.
  // Because HTTP headers are encoded in iso-8859-1,
  // we need to convert the utf-8(java encoding) strings to iso-8859-1 ones.
  static void convertHeaderCharsetFromIso88591(Map<String, String> headers) {
    convertHeaderCharset(headers, ISO_8859_1_CHARSET, UTF8_CHARSET);
  }

  // For response, convert from iso-8859-1 to utf-8.
  static void convertHeaderCharsetToIso88591(Map<String, String> headers) {
    convertHeaderCharset(headers, UTF8_CHARSET, ISO_8859_1_CHARSET);
  }

  static void convertHeaderCharset(
      Map<String, String> headers, String fromCharset, String toCharset) {
    headers.forEach((key, value) {
      if (value == null) {
        return;
      }

      try {
        headers[key] =
            String(header.getValue().getBytes(fromCharset), toCharset);
      } catch (e) {
        throw ArgumentError("Invalid charset name: $e");
      }
    });
  }
}
