import 'package:intl/intl.dart';

/// A simple utility class for date formating.
class DateUtil {
  // RFC 822 DateTime Format
  static final String RFC822_DATE_FORMAT = "EEE, dd MMM yyyy HH:mm:ss z";

  // ISO 8601 format
  static final String ISO8601_DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

  // Alternate ISO 8601 format without fractional seconds
  static final String ALTERNATIVE_ISO8601_DATE_FORMAT =
      "yyyy-MM-dd'T'HH:mm:ss'Z'";

  /// Formats DateTime to GMT string.
  static String formatRfc822Date(DateTime date) {
    return getRfc822DateFormat().format(date);
  }

  /// Parses a GMT-format string.
  static DateTime parseRfc822Date(String dateString) {
    return getRfc822DateFormat().parse(dateString);
  }

  static DateFormat getRfc822DateFormat() {
    DateFormat rfc822DateFormat = DateFormat(RFC822_DATE_FORMAT, 'US');
    rfc822DateFormat.setTimeZone(new SimpleTimeZone(0, "GMT"));

    return rfc822DateFormat;
  }

  static String formatIso8601Date(DateTime date) {
    return getIso8601DateFormat().format(date);
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
    DateFormat df = DateFormat(ISO8601_DATE_FORMAT, 'US');
    df.setTimeZone(new SimpleTimeZone(0, "GMT"));
    return df;
  }

  static DateFormat getAlternativeIso8601DateFormat() {
    DateFormat df =
        DateFormat(ALTERNATIVE_ISO8601_DATE_FORMAT, 'US');
    df.setTimeZone(new SimpleTimeZone(0, "GMT"));
    return df;
  }
}
