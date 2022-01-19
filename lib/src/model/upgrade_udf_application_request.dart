import 'udf_generic_request.dart';

class UpgradeUdfApplicationRequest extends UdfGenericRequest {
  UpgradeUdfApplicationRequest(String? udfName, this.imageVersion)
      : super(udfName);

  int? imageVersion;
}
