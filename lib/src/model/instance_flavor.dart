/// Instance Flavor
///
/// Udf Applacation's runtime.For the detail, please refer ECS document.
///
class InstanceFlavor {
  static final String defaultInstanceType = "ecs.n1.small";

  InstanceFlavor(this.instanceType);

  final String instanceType;

  @override
  String toString() {
    return "InstanceFlavor [instanceType=$instanceType]";
  }
}
