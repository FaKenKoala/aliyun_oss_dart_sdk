import 'generic_result.dart';

class BucketReferer extends GenericResult {
  bool allowEmptyReferer = true;
  final List<String> _refererList = [];

  BucketReferer(this.allowEmptyReferer, List<String>? refererList) {
    this.refererList = refererList;
  }

  List<String> getRefererList() {
    return _refererList;
  }

  set refererList(List<String>? refererList) {
    _refererList
      ..clear()
      ..addAll(refererList ?? []);
  }

  void clearRefererList() {
    _refererList.clear();
  }
}
