import 'owner.dart';

class OSSVersionSummary {
  /// The name of the bucket in which this version is stored
  String? bucketName;

  /// The key under which this version is stored
  String? key;

  /// The version ID uniquely identifying this version of an object
  String? versionId;

  /// True if this is the latest version of the associated object
  bool? isLatest;

  /// The date, according to OSS, when this version was last modified
  DateTime? lastModified;

  /// The owner of this version of the associated object - can be null if the
  /// requester doesn't have permission to view object ownership information
  Owner? owner;

  /// Hex encoded MD5 hash of this version's contents, as computed by OSS
  String? eTag;

  /// The size of this version, in bytes
  int? size;

  /// The class of storage used by OSS to store this version
  String? storageClass;

  /// True if this object represents a delete marker
  bool? isDeleteMarker;
}
