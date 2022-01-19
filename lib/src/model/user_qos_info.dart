import 'generic_result.dart';

class UserQosInfo extends GenericResult {
  String? region;
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
