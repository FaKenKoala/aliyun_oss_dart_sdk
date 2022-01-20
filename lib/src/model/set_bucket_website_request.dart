import 'generic_request.dart';
import 'routing_rule.dart';
import 'sub_dir_type.dart';

class SetBucketWebsiteRequest extends GenericRequest {
  String? indexDocument;
  String? errorDocument;
  bool supportSubDir = false;
  SubDirType? subDirType;

  final List<RoutingRule> _routingRules = [];

  SetBucketWebsiteRequest(String bucketName) : super(bucketName: bucketName);

  List<RoutingRule> getRoutingRules() {
    return _routingRules;
  }

  void setRoutingRules(List<RoutingRule>? routingRules) {
    if (routingRules?.isEmpty ?? true) {
      throw ArgumentError("routingRules should not be null or empty.");
    }

    for (RoutingRule rule in routingRules!) {
      rule.ensureRoutingRuleValid();
    }

    _routingRules
      ..clear()
      ..addAll(routingRules);
  }

  void addRoutingRule(RoutingRule routingRule) {
    routingRule.ensureRoutingRuleValid();
    _routingRules.add(routingRule);
  }
}
