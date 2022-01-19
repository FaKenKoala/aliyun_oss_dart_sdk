import 'web_service_request.dart';

/// A generic request that contains some basic request options, such as udf name
/// and so on.
class UdfGenericRequest extends WebServiceRequest {
  UdfGenericRequest([this.name]);
  String? name;
}
