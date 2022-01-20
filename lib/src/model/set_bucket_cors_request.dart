import 'generic_request.dart';

class SetBucketCORSRequest extends GenericRequest {
  static int MAX_CORS_RULE_LIMIT = 10;
  static String ASTERISK = '*';
  static List<String> ALL_ALLOWED_METHODS = <String>[
    "GET",
    "PUT",
    "DELETE",
    "POST",
    "HEAD"
  ];

  final List<CORSRule> _corsRules = [];

  bool? responseVary;

  SetBucketCORSRequest(String bucketName) : super(bucketName: bucketName);

  void addCorsRule(CORSRule corsRule) {
    checkCorsValidity(corsRule);
    _corsRules.add(corsRule);
  }

  void checkCorsValidity(CORSRule? corsRule) {
    if (corsRule == null) {
      throw ArgumentError("corsRule should not be null or empty.");
    }

    if (_corsRules.length >= MAX_CORS_RULE_LIMIT) {
      throw ArgumentError(
          "One bucket not allowed exceed ten items of CORS Rules.");
    }

    // At least one item of allowed origins
    if (corsRule.getAllowedOrigins().isEmpty) {
      throw ArgumentError(
          "Required field 'AllowedOrigins' should not be empty.");
    }

    // At least one item of allowed methods
    if (corsRule.getAllowedMethods().isEmpty) {
      throw ArgumentError(
          "Required field 'AllowedMethod' should not be empty.");
    }

    // At most one asterisk wildcard in allowed origins
    for (String origin in corsRule.getAllowedOrigins()) {
      if (countOfAsterisk(origin) > 1) {
        throw ArgumentError("At most one '*' wildcard in allowd origin.");
      }
    }

    // Unsupported method
    for (String method in corsRule.getAllowedMethods()) {
      if (!isAllowedMethod(method)) {
        throw ArgumentError(
            "Unsupported method " + method + ", (GET,PUT,DELETE,POST,HEAD)");
      }
    }

    // At most one asterisk wildcard in allowed headers
    for (String header in corsRule.getAllowedHeaders()) {
      if (countOfAsterisk(header) > 1) {
        throw ArgumentError("At most one '*' wildcard in allowd header.");
      }
    }

    // Not allow to use any asterisk wildcard in allowed origins
    for (String header in corsRule.getExposeHeaders()) {
      if (countOfAsterisk(header) > 0) {
        throw ArgumentError(
            "Not allow to use any '*' wildcard in expose header.");
      }
    }
  }

  static int countOfAsterisk(String? str) {
    if (str?.isEmpty ?? true) {
      return 0;
    }

    int from = 0;
    int pos = -1;
    int count = 0;
    int len = str!.length;
    do {
      pos = str.indexOf(ASTERISK, from);
      if (pos != -1) {
        count++;
        from = pos + 1;
      }
    } while (pos != -1 && from < len);

    return count;
  }

  static bool isAllowedMethod(String? method) {
    if (method?.isEmpty ?? true) {
      return false;
    }

    for (String m in ALL_ALLOWED_METHODS) {
      if (m == method) {
        return true;
      }
    }
    return false;
  }

  List<CORSRule> getCorsRules() {
    return _corsRules;
  }

  void setCorsRules(List<CORSRule>? corsRules) {
    if (corsRules?.isEmpty ?? true) {
      throw ArgumentError("corsRules should not be null or empty.");
    }

    if (corsRules!.length > MAX_CORS_RULE_LIMIT) {
      throw ArgumentError(
          "One bucket not allowed exceed ten items of CORS Rules.");
    }

    _corsRules
      ..clear()
      ..addAll(corsRules);
  }

  void clearCorsRules() {
    _corsRules.clear();
  }

  void setResponseVary(bool? responseVary) {
    this.responseVary = responseVary;
  }

  bool? getResponseVary() {
    return responseVary;
  }
}

class CORSRule {
  final List<String> _allowedOrigins = [];
  final List<String> _allowedMethods = [];
  final List<String> _allowedHeaders = [];
  final List<String> _exposeHeaders = [];

  int? maxAgeSeconds;

  void addAllowdOrigin(String? allowedOrigin) {
    if (allowedOrigin?.trim().isNotEmpty ?? false) {
      _allowedOrigins.add(allowedOrigin!);
    }
  }

  List<String> getAllowedOrigins() {
    return _allowedOrigins;
  }

  void setAllowedOrigins(List<String>? allowedOrigins) {
    _allowedOrigins
      ..clear
      ..addAll(allowedOrigins ?? []);
  }

  void clearAllowedOrigins() {
    _allowedOrigins.clear();
  }

  void addAllowedMethod(String? allowedMethod) {
    if (allowedMethod?.trim().isNotEmpty ?? false) {
      _allowedMethods.add(allowedMethod!);
    }
  }

  List<String> getAllowedMethods() {
    return _allowedMethods;
  }

  void setAllowedMethods(List<String>? allowedMethods) {
    _allowedMethods
      ..clear()
      ..addAll(allowedMethods ?? []);
  }

  void clearAllowedMethods() {
    _allowedMethods.clear();
  }

  void addAllowedHeader(String? allowedHeader) {
    if (allowedHeader?.trim().isNotEmpty ?? false) {
      _allowedHeaders.add(allowedHeader!);
    }
  }

  List<String> getAllowedHeaders() {
    return _allowedHeaders;
  }

  void setAllowedHeaders(List<String>? allowedHeaders) {
    _allowedHeaders
      ..clear
      ..addAll(allowedHeaders ?? []);
  }

  void clearAllowedHeaders() {
    _allowedHeaders.clear();
  }

  void addExposeHeader(String? exposeHeader) {
    if (exposeHeader?.trim().isNotEmpty ?? false) {
      _exposeHeaders.add(exposeHeader!);
    }
  }

  List<String> getExposeHeaders() {
    return _exposeHeaders;
  }

  void setExposeHeaders(List<String>? exposeHeaders) {
    _exposeHeaders
      ..clear()
      ..addAll(exposeHeaders ?? []);
  }

  void clearExposeHeaders() {
    _exposeHeaders.clear();
  }
}
