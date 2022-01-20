
 import 'generic_request.dart';
import 'lifecycle_rule.dart';

class SetBucketLifecycleRequest extends GenericRequest {

     static final int MAX_LIFECYCLE_RULE_LIMIT = 1000;
     static final int MAX_RULE_ID_LENGTH = 255;

     List<LifecycleRule> _lifecycleRules = [];

     SetBucketLifecycleRequest(String bucketName) :
        super(bucketName: bucketName);
    

     List<LifecycleRule> getLifecycleRules() {
        return _lifecycleRules;
    }

     void setLifecycleRules(List<LifecycleRule>? lifecycleRules) {
        if (lifecycleRules?.isEmpty??true) {
            throw ArgumentError("lifecycleRules should not be null or empty.");
        }

        if (lifecycleRules!.length > MAX_LIFECYCLE_RULE_LIMIT) {
            throw ArgumentError("One bucket not allow exceed one thousand items of LifecycleRules.");
        }

        _lifecycleRules..clear()..addAll(lifecycleRules);
    }

     void clearLifecycles() {
        _lifecycleRules.clear();
    }

     void addLifecycleRule(LifecycleRule? lifecycleRule) {
        if (lifecycleRule == null) {
            throw ArgumentError("lifecycleRule should not be null or empty.");
        }

        if (_lifecycleRules.length >= MAX_LIFECYCLE_RULE_LIMIT) {
            throw ArgumentError("One bucket not allow exceed one thousand items of LifecycleRules.");
        }

        if (lifecycleRule.id != null && lifecycleRule.id!.length > MAX_RULE_ID_LENGTH) {
            throw ArgumentError("Length of lifecycle rule id exceeds max limit $MAX_RULE_ID_LENGTH");
        }

        int expirationTimeFlag = lifecycleRule.hasExpirationTime() ? 1 : 0;
        int expirationDaysFlag = lifecycleRule.hasExpirationDays() ? 1 : 0;
        int createdBeforeDateFlag = lifecycleRule.hasCreatedBeforeDateTime() ? 1 : 0;
        int expiredDeleteMarkerFlag = lifecycleRule.hasExpiredDeleteMarker() ? 1: 0;
        int flagSum = expirationTimeFlag + expirationDaysFlag + createdBeforeDateFlag + expiredDeleteMarkerFlag;
        if (flagSum > 1 ) {
            throw ArgumentError("Only one expiration property should be specified.");
        }

        if (flagSum == 0 && !lifecycleRule.hasAbortMultipartUpload()
                && !lifecycleRule.hasStorageTransition() && !lifecycleRule.hasNoncurrentVersionStorageTransitions()
                && !lifecycleRule.hasNoncurrentVersionExpiration()) {
            throw ArgumentError("Rule has none expiration or transition specified.");
        }

        if (lifecycleRule.status == RuleStatus.unknown) {
            throw ArgumentError("RuleStatus property should be specified with 'Enabled' or 'Disabled'.");
        }

        if (lifecycleRule.hasAbortMultipartUpload()) {
            AbortMultipartUpload? abortMultipartUpload = lifecycleRule.abortMultipartUpload;
            expirationDaysFlag = (abortMultipartUpload?.hasExpirationDays()??false) ? 1 : 0;
            createdBeforeDateFlag = (abortMultipartUpload?.hasCreatedBeforeDateTime()??false) ? 1 : 0;
            flagSum = expirationDaysFlag + createdBeforeDateFlag;
            if (flagSum != 1) {
                throw ArgumentError(
                        "Only one expiration property for AbortMultipartUpload should be specified.");
            }
        }

        if (lifecycleRule.hasStorageTransition()) {
            for (StorageTransition storageTransition in lifecycleRule.storageTransitions) {
                expirationDaysFlag = storageTransition.hasExpirationDays() ? 1 : 0;
                createdBeforeDateFlag = storageTransition.hasCreatedBeforeDateTime() ? 1 : 0;
                flagSum = expirationDaysFlag + createdBeforeDateFlag;
                if (flagSum != 1) {
                    throw ArgumentError(
                            "Only one expiration property for StorageTransition should be specified.");
                }
            }
        }

        _lifecycleRules.add(lifecycleRule);
    }
}
