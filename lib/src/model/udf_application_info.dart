import 'generic_result.dart';
import 'instance_flavor.dart';

class UdfApplicationInfo extends GenericResult {
  UdfApplicationInfo(
    this.name,
    this.id,
    this.region,
    this.status,
    this.imageVersion,
    this.instanceNum,
    this.creationDate,
    this.flavor,
  );

  @override
  String toString() {
    return "UdfApplicationInfo [name=$name, id=$id, region=$region, status=$status, imageVersion=$imageVersion, instanceNum=$instanceNum, creationDate=$creationDate, flavor=$flavor]";
  }

  String? name;
  String? id;
  String? region;
  String? status;
  int? imageVersion;
  int? instanceNum;
  DateTime? creationDate;
  InstanceFlavor? flavor;
}
