import 'canned_access_control_list.dart';
import 'oss_request.dart';
import 'storage_class.dart';

class CreateBucketRequest extends OSSRequest {
  static final String TAB_LOCATIONCONSTRAINT = "LocationConstraint";
  static final String TAB_STORAGECLASS = "StorageClass";
  String bucketName;
  CannedAccessControlList? bucketACL;

  /// Sets the location constraint.
  /// Valid values：oss-cn-hangzhou、oss-cn-qingdao、oss-cn-beijing、oss-cn-hongkong、oss-cn-shenzhen、
  /// oss-cn-shanghai、oss-us-west-1 、oss-ap-southeast-1
  /// If it's not specified，the default value is oss-cn-hangzhou
  String? locationConstraint;
  StorageClass bucketStorageClass = StorageClass.Standard;

  CreateBucketRequest(this.bucketName);
}
