import 'generic_result.dart';
import 'routing_rule.dart';

class BucketWebsiteResult extends GenericResult {
  String? indexDocument;
  String? errorDocument;
  bool supportSubDir = false;
  String? subDirType;
  final List<RoutingRule> _routingRules = [];

  List<RoutingRule> get routingRules {
    return _routingRules;
  }

  void addRoutingRule(RoutingRule routingRule) {
    routingRule.ensureRoutingRuleValid();
    _routingRules.add(routingRule);
  }
}
