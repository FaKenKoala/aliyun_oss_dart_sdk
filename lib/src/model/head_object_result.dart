 import 'object_metadata.dart';

import 'oss_result.dart';

class HeadObjectResult extends OSSResult {

    // object metadata
     ObjectMetadata metadata = ObjectMetadata();

    @override
     String toString() {
        return "HeadObjectResult<${super}>:\n metadata:$metadata";
    }
}
