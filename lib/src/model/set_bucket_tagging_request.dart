import 'package:aliyun_oss_dart_sdk/src/model/tag_set.dart';

import 'set_tagging_request.dart';

class SetBucketTaggingRequest extends SetTaggingRequest {
  SetBucketTaggingRequest(String bucketName,
      {Map<String, String>? tags, TagSet? tagSet})
      : super(bucketName, null, tagSet: tagSet, tags: tags);
}
