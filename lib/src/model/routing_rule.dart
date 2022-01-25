// ignore_for_file: constant_identifier_names

import 'package:aliyun_oss_dart_sdk/src/common/comm/protocol.dart';
import 'package:aliyun_oss_dart_sdk/src/oss_error_code.dart';

import '../client_exception.dart';

/// A rule that identifies a condition and the redirect that is applied when the
/// condition is met.
class RoutingRule {
  void ensureRoutingRuleValid() {
    if (number == null || number! <= 0) {
      throw ArgumentError("RoutingRuleNumberInvalid: $number");
    }

    redirect.ensureRedirectValid();

    condition.ensureConditionValid();
  }

  /// RuleNumber must be a positive int, can not be continuous, but must be
  /// increased, can not be repeated. Condition matching to consider in
  /// accordance with the order of rule to do, because it is difficult to
  /// ensure that there is no rule between overlap.
  int? number;

  /// Container for describing a condition that must be met for the specified
  /// redirect to be applied.

  Condition condition = Condition();

  /// Container element that provides instructions for redirecting the request.
  Redirect redirect = Redirect();
}

/// Container for describing a condition that must be met for the specified
/// redirect to be applied. If the routing rule does not include a condition,
/// the rule is applied to all requests.
class Condition {
  int? get httpErrorCodeReturnedEquals => _httpErrorCodeReturnedEquals;

  void setHttpErrorCodeReturnedEquals(int? httpErrorCodeReturnedEquals) {
    if (httpErrorCodeReturnedEquals == null) {
      return;
    }

    if (httpErrorCodeReturnedEquals <= 0) {
      throw ArgumentError(
          "HttpErrorCodeReturnedEqualsInvalid: HttpErrorCodeReturnedEquals should be greater than 0");
    }

    _httpErrorCodeReturnedEquals = httpErrorCodeReturnedEquals;
  }

  void ensureConditionValid() {}

  /// The object key name prefix from which requests will be redirected.
  String? keyPrefixEquals;

  /// The object key name prefix from which requests will be redirected.
  String? keySuffixEquals;

  /// The HTTP error code that must match for the redirect to apply. In the
  /// event of an error, if the error code meets this value, then specified
  /// redirect applies.
  int? _httpErrorCodeReturnedEquals;

  List<IncludeHeader>? includeHeaders;
}

class IncludeHeader {
  /// name of header
  String? key;

  /// key should be equal to the given value
  String? equals;

  /// key should be start with the given value
  String? startsWith;

  /// key should be end with the given value
  String? endsWith;
}

enum RedirectType {
  /// Internal mode is not supported yet.
  Internal,

  /// 302 redirect.
  External,

  /// AliCDN
  AliCDN,

  /// Means OSS would read the source data on user's behalf and store it in
  /// OSS for later access.
  Mirror,
}

extension RedirectTypeX on RedirectType {
  static RedirectType parse(String redirectTypeString) {
    for (RedirectType rt in RedirectType.values) {
      if (rt.name == redirectTypeString) {
        return rt;
      }
    }

    throw ArgumentError("Unable to parse $redirectTypeString");
  }
}

class MirrorMultiAlternate {
  int? _prior;
  String? url;

  int? get prior => _prior;

  void setPrior(int prior) {
    if (prior < 1 || prior > 10000) {
      throw ClientException("The specified prior is not valid",
          OSSErrorCode.INVALID_ARGUMENT, null);
    }
    _prior = prior;
  }
}

class MirrorHeaders {
  /// Flags of passing all headers to source site.
  bool passAll = false;

  /// Only headers include in list can be passed to source site.
  List<String>? pass;

  /// Headers include in list cannot be passed to source site.
  List<String>? remove;

  /// Define the value for some headers.
  List<Map<String, String>>? set;
}

/// Container element that provides instructions for redirecting the request.
/// You can redirect requests to another host, or another page, or you can
/// specify another protocol to use.
class Redirect {
  int? get httpRedirectCode {
    return _httpRedirectCode;
  }

  void setHttpRedirectCode(int? httpRedirectCode) {
    if (httpRedirectCode == null) {
      return;
    }

    if (httpRedirectCode < 300 || httpRedirectCode > 399) {
      throw ArgumentError(
          "RedirectHttpRedirectCodeInvalid: HttpRedirectCode must be a valid HTTP 3xx status code.");
    }

    _httpRedirectCode = httpRedirectCode;
  }

  /// A Redirect element must contain at least one of the following sibling
  /// elements.
  void ensureRedirectValid() {
    if (hostName == null &&
        protocol == null &&
        replaceKeyPrefixWith == null &&
        replaceKeyWith == null &&
        _httpRedirectCode == null &&
        mirrorURL == null) {
      throw ArgumentError(
          "RoutingRuleRedirectInvalid: Redirect element must contain at least one of the sibling elements");
    }

    if (replaceKeyPrefixWith != null && replaceKeyWith != null) {
      throw ArgumentError(
          "RoutingRuleRedirectInvalid: ReplaceKeyPrefixWith or ReplaceKeyWith only choose one");
    }

    if (redirectType == RedirectType.Mirror && mirrorURL == null) {
      throw ArgumentError(
          "RoutingRuleRedirectInvalid: MirrorURL must have a value");
    }

    if (redirectType == RedirectType.Mirror) {
      final mirrorURL = this.mirrorURL!;
      if ((!mirrorURL.startsWith("http://") &&
              !mirrorURL.startsWith("https://")) ||
          !mirrorURL.endsWith("/")) {
        throw ArgumentError(
            "RoutingRuleRedirectInvalid MirrorURL is invalid: $mirrorURL");
      }
    }
  }

  /// Redirect type, Internal, External or Mirror
  RedirectType? redirectType;

  /// The host name to be used in the Location header that is returned in
  /// the response. HostName is not required if one of its siblings is
  /// supplied.
  String? hostName;

  /// The protocol, http or https, to be used in the Location header that
  /// is returned in the response. Protocol is not required if one of its
  /// siblings is supplied.
  Protocol? protocol;

  /// The object key name prefix that will replace the value of
  /// KeyPrefixEquals in the redirect request. ReplaceKeyPrefixWith is not
  /// required if one of its siblings is supplied. It can be supplied only
  /// if ReplaceKeyWith is not supplied.
  String? replaceKeyPrefixWith;

  /// The object key to be used in the Location header that is returned in
  /// the response. ReplaceKeyWith is not required if one of its siblings
  /// is supplied. It can be supplied only if ReplaceKeyPrefixWith is not
  /// supplied.
  String? replaceKeyWith;

  /// The HTTP redirect code to be used in the Location header that is
  /// returned in the response. HttpRedirectCode is not required if one of
  /// its siblings is supplied.
  int? _httpRedirectCode;

  /// MirrorURL is effective when RedirectType is Mirror
  String? mirrorURL;

  /// The secondary URL for mirror. It should be same as mirrorURL. When
  /// the primary mirror url is not available, OSS would switch to
  /// secondary URL automatically.
  String? mirrorSecondaryURL;

  /// The probe URL for mirror. This is to detect the availability of the
  /// primary mirror URL. If it does not return 200, then switch to
  /// secondary mirror URL. If it returns 200, switch to primary mirror
  /// URL.
  String? mirrorProbeURL;

  /// Flag of passing the query string to the source site. By default it's
  /// false. The passQueryString applies to all kind of RoutingRule while the mirrorPassQueryString can only work on Back-to-Origin.
  bool? passQueryString;

  /// Flag of passing the query string to the source site. By default it's
  /// false.
  bool? mirrorPassQueryString;

  /// Flag of passing the redundant backslash between host and uri to
  /// source site. By default it's false.
  bool? passOriginalSlashes;

  /// Flags of following with the 3xx response from source site. By default it's true.
  bool mirrorFollowRedirect = true;

  /// Flags of accepting the user-setting of lastModifiedTime in the response from source site. By default it's false.
  bool? mirrorUserLastModified;

  /// Flags of take high-speed channel on Back-to-Origin. By default it's false.
  bool? mirrorIsExpressTunnel;

  /// Need when the mirrorIsExpressTunnel is true, means the destination region for high-speed channel.
  String? mirrorDstRegion;

  /// The vpc id of destination when taking high-speed channel on Back-to-Origin.
  String? mirrorDstVpcId;

  MirrorHeaders? mirrorHeaders;

  List<MirrorMultiAlternate>? mirrorMultiAlternates;

  /// the role of back to  bucket
  String? mirrorRole;

  /// check if use the role to back to  bucket
  bool? mirrorUsingRole;

  /// replace or instead
  bool? enableReplacePrefix;

  /// MirrorSwitchAllErrors
  bool? mirrorSwitchAllErrors;

  /// checkMd5
  bool? mirrorCheckMd5;

  /// tunnel
  String? mirrorTunnelId;
}
