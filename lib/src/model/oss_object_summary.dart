import 'owner.dart';

/// OSSObject summary class definition.
class OSSObjectSummary {
  /// The name of the bucket in which this object is stored
  String? bucketName;

  /// The key under which this object is stored
  String? key;

  String? type;

  String? eTag;

  int size = 0;

  DateTime? lastModified;

  String? storageClass;

  /// {@link Owner}
  Owner? owner;
}
