import 'generic_request.dart';
import 'tag_set.dart';

class SetTaggingRequest extends GenericRequest {
  TagSet tagSet;

  SetTaggingRequest(String bucketName, String key,
      {TagSet? tagSet, Map<String, String>? tags})
      : tagSet = tagSet ?? TagSet(tags),
        super(bucketName: bucketName, key: key);

  void setTag(String key, String value) {
    tagSet.setTag(key, value);
  }

  String? getTag(String key) {
    return tagSet.getTag(key);
  }
}
