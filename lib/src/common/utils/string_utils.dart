/// Utilities for converting objects to strings.
class StringUtils {
  static final String DEFAULT_ENCODING = "UTF-8";

  static final String COMMA_SEPARATOR = ",";

  // white space character that match Pattern.compile("\\s")
  static final String CHAR_SPACE = ' ';
  static final String CHAR_TAB = '\t';
  static final String CHAR_NEW_LINE = '\n';
  static final String CHAR_VERTICAL_TAB = '\u000b';
  static final String CHAR_CARRIAGE_RETURN = '\r';
  static final String CHAR_FORM_FEED = '\f';

  static int toint(StringBuffer value) {
    return int.parse(value.toString());
  }

  static String toSBString(StringBuffer value) {
    return value.toString();
  }

  static bool tobool(StringBuffer value) {
    return value.toString().toLowerCase() == 'true';
  }

  static String fromint(int value) {
    return '$value';
  }

  static String fromString(String value) {
    return value;
  }

  static String frombool(bool value) {
    return '$value';
  }

  static String fromDouble(double value) {
    return '$value';
  }

  static String replace(
      String originalString, String partToMatch, String replacement) {
    return originalString.replaceAll(partToMatch, replacement);
  }

  static String join(String joiner, List<String> parts) {
    return parts.join(joiner);
  }

  static String? trim(String? value) {
    if (value == null) {
      return null;
    }
    return value.trim();
  }

  /// @return true if the given value is either null or the empty string
  static bool isNullOrEmpty(String? value) {
    return value?.isEmpty ?? true;
  }

  /// @return true if the given value is non-null and non-empty
  static bool hasValue(String? str) {
    return !isNullOrEmpty(str);
  }

  static String? lowerCase(String? str) {
    return str?.toLowerCase();
  }

  static String? upperCase(String? str) {
    return str?.toUpperCase();
  }

  static int compare(String? str1, String? str2) {
    if (str1 == null || str2 == null) {
      throw ArgumentError("Arguments cannot be null");
    }

    return str1.compareTo(str2);
  }

  static bool isWhiteSpace(final String ch) {
    return [
      CHAR_SPACE,
      CHAR_TAB,
      CHAR_NEW_LINE,
      CHAR_VERTICAL_TAB,
      CHAR_CARRIAGE_RETURN,
      CHAR_FORM_FEED
    ].contains(ch);
  }

  /// This method appends a string to a string builder and collapses contiguous
  /// white space is a single space.
  ///
  /// This is equivalent to:
  ///      destination.append(source.replaceAll("\\s+", " "))
  /// but does not create a Pattern object that needs to compile the match
  /// string; it also prevents us from having to make a Matcher object as well.
  ///
  static void appendCompactedString(
      final StringBuffer destination, final String source) {
    bool previousIsWhiteSpace = false;
    int length = source.length;

    for (int i = 0; i < length; i++) {
      String ch = source.substring(i, i + 1);
      if (isWhiteSpace(ch)) {
        if (previousIsWhiteSpace) {
          continue;
        }
        destination.write(CHAR_SPACE);
        previousIsWhiteSpace = true;
      } else {
        destination.write(ch);
        previousIsWhiteSpace = false;
      }
    }
  }

  /// Performs a case insensitive comparison and returns true if the data
  /// begins with the given sequence.
  static bool beginsWithIgnoreCase(final String data, final String seq) {
    return data.toLowerCase().startsWith(seq.toLowerCase());
  }
}
