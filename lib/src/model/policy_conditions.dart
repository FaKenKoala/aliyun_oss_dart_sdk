// ignore_for_file: constant_identifier_names

import 'match_mode.dart';

/// One condition item
/// The condition tuple type: currently only supports Two and Three.
enum TupleType {
  Two,
  Three,
}

class ConditionItem {
  String name;
  MatchMode matchMode;
  String? value;
  TupleType tupleType;
  int minimum = 0;
  int maximum = 0;

  ConditionItem.two(this.name, this.value)
      : matchMode = MatchMode.exact,
        tupleType = TupleType.Two;

  ConditionItem.three(this.name, this.minimum, this.maximum)
      : matchMode = MatchMode.range,
        tupleType = TupleType.Three;

  ConditionItem.matchMode(this.matchMode, this.name, this.value)
      : tupleType = TupleType.Three;

  String jsonize() {
    String? jsonizedCond;
    switch (tupleType) {
      case TupleType.Two:
        jsonizedCond = '{"$name":"$value"},';
        break;
      case TupleType.Three:
        switch (matchMode) {
          case MatchMode.exact:
            jsonizedCond = '["eq","\$$name","$value"],';
            break;
          case MatchMode.startWith:
            jsonizedCond = '["starts-with","\$$name","$value"],';
            break;
          case MatchMode.range:
            jsonizedCond = '["content-length-range",$minimum,$maximum],';
            break;
          default:
            throw ArgumentError("Unsupported match mode ${matchMode.name}");
        }
        break;
    }

    return jsonizedCond;
  }
}

/// Policy Conditions. This is to specify the conditions in a post request.
class PolicyConditions {
  static String condContentLengthRange = "content-length-range";
  static String condCacheControl = "Cache-Control";
  static String condContentType = "Content-Type";
  static String condContentDisposition = "Content-Disposition";
  static String condContentEncoding = "Content-Encoding";
  static String condExpires = "Expires";
  static String condKey = "key";
  static String condSuccessActionRedirect = "success_action_redirect";
  static String condSuccessActionStatus = "success_action_status";
  static String condXOssMetaPrefix = "x-oss-meta-";
  static String condXOssServerSidePrefix = "x-oss-server-side-";

  static final Map<String, List<MatchMode>> _supportedMatchRules =
      <String, List<MatchMode>>{};

  Map<String, List<MatchMode>> get supportedMatchRules {
    if (_supportedMatchRules.isEmpty) {
      final List<MatchMode> ordinaryMatchModes = [
        MatchMode.exact,
        MatchMode.startWith
      ];
      final List<MatchMode> specialMatchModes = [
        MatchMode.range,
      ];
      _supportedMatchRules.addAll({
        condContentLengthRange: specialMatchModes,
        condCacheControl: ordinaryMatchModes,
        condContentType: ordinaryMatchModes,
        condContentDisposition: ordinaryMatchModes,
        condContentEncoding: ordinaryMatchModes,
        condExpires: ordinaryMatchModes,
        condKey: ordinaryMatchModes,
        condSuccessActionRedirect: ordinaryMatchModes,
        condSuccessActionStatus: ordinaryMatchModes,
        condXOssMetaPrefix: ordinaryMatchModes,
        condXOssServerSidePrefix: ordinaryMatchModes,
      });
    }
    return _supportedMatchRules;
  }

  final List<ConditionItem> _conds = [];

  /// Adds a condition item with the exact match mode.
  void addConditionItemWithTwo(String name, String value) {
    checkMatchModes(MatchMode.exact, name);
    _conds.add(ConditionItem.two(name, value));
  }

  /// Adds a condition item with specified {@link MatchMode} value.
  void addConditionItemWithMatchMode(
      MatchMode matchMode, String name, String value) {
    checkMatchModes(matchMode, name);
    _conds.add(ConditionItem.matchMode(matchMode, name, value));
  }

  /// Adds a range match condition.
  void addConditionItemWithThree(String name, int min, int max) {
    if (min > max) {
      throw ArgumentError("Invalid range [$min, $max].");
    }
    _conds.add(ConditionItem.three(name, min, max));
  }

  void checkMatchModes(MatchMode matchMode, String condName) {
    if (_supportedMatchRules.containsKey(condName)) {
      List<MatchMode> mms = _supportedMatchRules[condName]!;
      if (!mms.contains(matchMode)) {
        throw ArgumentError(
            "Unsupported match mode for condition item $condName");
      }
    }
  }

  String jsonize() {
    StringBuffer jsonizedConds = StringBuffer();
    jsonizedConds.write('"conditions":[');
    for (ConditionItem cond in _conds) {
      jsonizedConds.write(cond.jsonize());
    }
    String result = jsonizedConds.toString();
    if (_conds.isNotEmpty) {
      result = result.substring(0, result.length - 1);
    }
    return "$result]";
  }
}
