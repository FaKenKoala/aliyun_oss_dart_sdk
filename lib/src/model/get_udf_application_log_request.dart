import 'udf_generic_request.dart';

class GetUdfApplicationLogRequest extends UdfGenericRequest {
  GetUdfApplicationLogRequest(String udfName, [this.startTime, this.endLines])
      : super(udfName);

  DateTime? startTime;
  int? endLines;
}
