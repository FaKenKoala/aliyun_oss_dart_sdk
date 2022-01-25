/// Util class for DateTime.
class DateUtil {
  // RFC 822 DateTime Format
  static final String RFC822_DATE_FORMAT = "EEE, dd MMM yyyy HH:mm:ss 'GMT'";
  // ISO 8601 format
  static final String ISO8601_DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
  // Alternate ISO 8601 format without fractional seconds
  static final String ALTERNATIVE_ISO8601_DATE_FORMAT =
      "yyyy-MM-dd'T'HH:mm:ss'Z'";
  static int amendTimeSkewed = 0;

  /// Formats DateTime to GMT string.
  ///
  /// @param date
  /// @return
  static String formatRfc822Date(DateTime date) {
    return getRfc822DateFormat().format(date);
  }

  /// Parses a GMT-format string.
  ///
  /// @param dateString
  /// @return
  /// @throws ParseException
  static DateTime parseRfc822Date(String dateString) {
    return getRfc822DateFormat().parse(dateString);
  }

  static DateFormat getRfc822DateFormat() {
    SimpleDateFormat rfc822DateFormat =
        SimpleDateFormat(RFC822_DATE_FORMAT, Locale.US);
    rfc822DateFormat.setTimeZone(SimpleTimeZone(0, "GMT"));

    return rfc822DateFormat;
  }

  static String formatIso8601Date(DateTime date) {
    return getIso8601DateFormat().format(date);
  }

  static String formatAlternativeIso8601Date(DateTime date) {
    return getAlternativeIso8601DateFormat().format(date);
  }

  /// Parse a date string in the format of ISO 8601.
  ///
  /// @param dateString
  /// @return
  /// @throws ParseException
  static DateTime parseIso8601Date(String dateString) {
    try {
      return getIso8601DateFormat().parse(dateString);
    } catch (e) {
      return getAlternativeIso8601DateFormat().parse(dateString);
    }
  }

  static DateFormat getIso8601DateFormat() {
    SimpleDateFormat df = SimpleDateFormat(ISO8601_DATE_FORMAT, Locale.US);
    df.setTimeZone(SimpleTimeZone(0, "GMT"));

    return df;
  }

  static DateFormat getAlternativeIso8601DateFormat() {
    SimpleDateFormat df =
        SimpleDateFormat(ALTERNATIVE_ISO8601_DATE_FORMAT, Locale.US);
    df.setTimeZone(SimpleTimeZone(0, "GMT"));

    return df;
  }

  static int getFixedSkewedTimeMillis() {
    return currentTimeMillis + amendTimeSkewed;
  }

  static String currentFixedSkewedTimeInRFC822Format() {
    return formatRfc822Date(DateTime(getFixedSkewedTimeMillis()));
  }

  static void setCurrentServerTime(int serverTime) {
    amendTimeSkewed = serverTime - currentTimeMillis;
  }

  static int get currentTimeMillis => DateTime.now().millisecondsSinceEpoch;
  static int get currentTimeSecond =>
      DateTime.now().millisecondsSinceEpoch ~/ 1000;
}
