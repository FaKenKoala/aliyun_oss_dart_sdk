import 'generic_result.dart';

class TagSet extends GenericResult {
  Map<String, String> tags = <String, String>{};

  TagSet(Map<String, String>? tags) {
    this.tags.addAll(tags ?? {});
  }

  String? getTag(String key) {
    return tags[key];
  }

  void setTag(String key, String value) {
    tags[key] = value;
  }

  Map<String, String> getAllTags() => tags;

  void clear() {
    tags.clear();
  }

  @override
  String toString() {
    return "{Tags: $tags}";
  }
}
