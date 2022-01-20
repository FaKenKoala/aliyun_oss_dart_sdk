import 'package:aliyun_oss_dart_sdk/src/model/tag_set.dart';

import 'set_tagging_request.dart';

class SetObjectTaggingRequest extends SetTaggingRequest {
  SetObjectTaggingRequest(String bucketName, String key,
      [TagSet? tagSet, Map<String, String>? tags])
      : super(bucketName, key, tagSet: tagSet, tags: tags);
}
