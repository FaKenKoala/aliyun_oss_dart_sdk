/// Utils for common coding.
class CodingUtils {
  static void assertParameterNotNull(Object? param, String paramName) {
    if (param == null) {
      throw Exception(OSSUtils.COMMON_RESOURCE_MANAGER.getFormattedString(
          "ParameterIsNull", paramName));
    }
  }

  static void assertParameterInRange(int param, int lower, int upper) {
    if (!checkParamRange(param, lower, true, upper, true)) {
      throw ArgumentError("$param not in valid range [$lower, $upper]");
    }
  }

  static void assertStringNotNullOrEmpty(String? param, String paramName) {
    assertParameterNotNull(param, paramName);
    if (param!.trim().isEmpty) {
      throw ArgumentError(OSSUtils.COMMON_RESOURCE_MANAGER.getFormattedString(
          "ParameterStringIsEmpty", paramName));
    }
  }

  static void assertListNotNullOrEmpty(List param, String paramName) {
    assertParameterNotNull(param, paramName);
    if (param.isEmpty) {
      throw ArgumentError(OSSUtils.COMMON_RESOURCE_MANAGER.getFormattedString(
          "ParameterListIsEmpty", paramName));
    }
  }

  static bool isNullOrEmpty(String? value) {
    return value?.isEmpty ?? true;
  }

  static void assertTrue(bool condition, String message) {
    if (!condition) {
      throw ArgumentError(message);
    }
  }

  static bool checkParamRange(
      int param, int from, bool leftInclusive, int to, bool rightInclusive) {
    if (leftInclusive && rightInclusive) {
      // [from, to]
      if (from <= param && param <= to) {
        return true;
      } else {
        return false;
      }
    } else if (leftInclusive && !rightInclusive) {
      // [from, to)
      if (from <= param && param < to) {
        return true;
      } else {
        return false;
      }
    } else if (!leftInclusive && !rightInclusive) {
      // (from, to)
      if (from < param && param < to) {
        return true;
      } else {
        return false;
      }
    } else {
      // (from, to]
      if (from < param && param <= to) {
        return true;
      } else {
        return false;
      }
    }
  }
}
