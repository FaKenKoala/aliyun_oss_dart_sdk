import 'udf_application_configuration.dart';
import 'udf_generic_request.dart';

class CreateUdfApplicationRequest extends UdfGenericRequest {
  CreateUdfApplicationRequest(String udfName, this.udfApplicationConfiguration)
      : super(udfName);

  UdfApplicationConfiguration udfApplicationConfiguration;
}
