import 'udf_generic_request.dart';

class ResizeUdfApplicationRequest extends UdfGenericRequest {
  ResizeUdfApplicationRequest(String udfName, this.instanceNum)
      : super(udfName);

  int? instanceNum;
}
