import 'canned_udf_acl.dart';
import 'generic_result.dart';

class UdfInfo extends GenericResult {
  UdfInfo({
    this.name,
    this.owner,
    this.id,
    this.desc,
    this.acl,
    this.creationDate,
  });

  String? name;
  String? owner;
  String? id;
  String? desc;
  CannedUdfAcl? acl;
  DateTime? creationDate;

  @override
  String toString() {
    return "UdfInfo [name=$name, owner=$owner, id=$id, desc=$desc, acl=$acl, creationDate=$creationDate]";
  }
}
