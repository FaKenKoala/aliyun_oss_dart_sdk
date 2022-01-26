import 'package:intl/intl.dart';

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
  static String formatRfc822Date(DateTime date) {
    return getRfc822DateFormat().format(date.toUtc());
  }

  /// Parses a GMT-format string.
  static DateTime parseRfc822Date(String dateString) {
    return getRfc822DateFormat().parse(dateString);
  }

  static DateFormat getRfc822DateFormat() {
    return DateFormat(RFC822_DATE_FORMAT, 'en-us');
  }

  static String formatIso8601Date(DateTime date) {
    return getIso8601DateFormat().format(date.toUtc());
  }

  static String formatAlternativeIso8601Date(DateTime date) {
    return getAlternativeIso8601DateFormat().format(date);
  }

  /// Parse a date string in the format of ISO 8601.
  static DateTime parseIso8601Date(String dateString) {
    try {
      return getIso8601DateFormat().parse(dateString);
    } catch (e) {
      return getAlternativeIso8601DateFormat().parse(dateString);
    }
  }

  static DateFormat getIso8601DateFormat() {
    return DateFormat(ISO8601_DATE_FORMAT, 'en-US');
  }

  static DateFormat getAlternativeIso8601DateFormat() {
    return DateFormat(ALTERNATIVE_ISO8601_DATE_FORMAT, 'en-US');
  }

  static int getFixedSkewedTimeMillis() {
    return DateTime.now().millisecondsSinceEpoch + amendTimeSkewed;
  }

  static String currentFixedSkewedTimeInRFC822Format() {
    return formatRfc822Date(DateTime(getFixedSkewedTimeMillis()));
  }

  static void setCurrentServerTime(int serverTime) {
    amendTimeSkewed = serverTime - DateTime.now().millisecondsSinceEpoch;
  }

  // static int get currentTimeMillis => DateTime.now().millisecondsSinceEpoch;
  // static int get currentTimeSecond =>
  //     DateTime.now().millisecondsSinceEpoch ~/ 1000;
}
