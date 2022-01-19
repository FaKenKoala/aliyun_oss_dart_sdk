import 'generic_result.dart';

class BucketQosInfo extends GenericResult {
  int? totalUplaodBw;
  int? intranetUploadBw;
  int? extranetUploadBw;
  int? totalDownloadBw;
  int? intranetDownloadBw;
  int? extranetDownloadBw;
  int? totalQps;
  int? intranetQps;
  int? extranetQps;
}
