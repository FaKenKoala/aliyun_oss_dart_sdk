import 'generic_request.dart';
import 'transfer_acceleration.dart';

/// Bucket TransferAcceleration Configuration
class SetBucketTransferAccelerationRequest extends GenericRequest {
  TransferAcceleration transferAcceleration = TransferAcceleration(false);

  SetBucketTransferAccelerationRequest(String bucketName, bool enabled)
      : super(bucketName: bucketName) {
    setEnabled(enabled);
  }

  bool isEnabled() {
    return transferAcceleration.enabled;
  }

  void setEnabled(bool enabled) {
    transferAcceleration.enabled = enabled;
  }
}
