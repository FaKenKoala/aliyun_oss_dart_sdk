 import 'oss_result.dart';

class GetBucketRefererResult extends OSSResult {
     String? allowEmpty;
     List<String>? referers;


     void addReferer(String object) {
        referers ??= [];
        referers!.add(object);
    }
}
