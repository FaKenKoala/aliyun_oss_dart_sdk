import 'udf_generic_request.dart';

/// The request that is used to create UDF.
class CreateUdfRequest extends UdfGenericRequest {
  CreateUdfRequest(String name, {this.id, this.desc}) : super(name);

  String? id;
  String? desc;
}
