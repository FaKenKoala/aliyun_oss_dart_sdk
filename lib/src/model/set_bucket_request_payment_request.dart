import 'generic_request.dart';
import 'payer.dart';

class SetBucketRequestPaymentRequest extends GenericRequest {
  SetBucketRequestPaymentRequest(String bucketName, [Payer? payer])
      : super(bucketName: bucketName) {
    this.payer = payer;
  }
}
