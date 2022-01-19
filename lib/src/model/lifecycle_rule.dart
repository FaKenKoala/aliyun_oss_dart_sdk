// ignore_for_file: unnecessary_this

import 'storage_class.dart';

enum RuleStatus {
  unknown,
  // the rule is enabled.
  enabled,
  // The rule is disabled.
  disabled,
}

/// Life cycle rule class.
class LifecycleRule {
  LifecycleRule({
    this.id,
    this.prefix,
    this.status = RuleStatus.unknown,
    this.expirationDays,
    this.expirationTime,
    this.abortMultipartUpload,
    List<StorageTransition>? storageTransitions,
  }) {
    this.storageTransitions.addAll(storageTransitions ?? []);
  }

  String? id;
  String? prefix;
  RuleStatus status;
  int? expirationDays;
  DateTime? expirationTime;
  DateTime? createdBeforeDateTime;
  bool? expiredDeleteMarker;

  AbortMultipartUpload? abortMultipartUpload;
  List<StorageTransition> storageTransitions = [];
  Map<String, String> tags = <String, String>{};
  NoncurrentVersionExpiration? noncurrentVersionExpiration;
  List<NoncurrentVersionStorageTransition> noncurrentVersionStorageTransitions =
      [];

  bool hasExpirationDays() {
    return expirationDays != 0;
  }

  bool hasExpirationTime() {
    return expirationTime != null;
  }

  bool hasCreatedBeforeDateTime() {
    return createdBeforeDateTime != null;
  }

  bool hasExpiredDeleteMarker() {
    return expiredDeleteMarker != null;
  }

  bool hasAbortMultipartUpload() {
    return abortMultipartUpload != null;
  }

  bool hasStorageTransition() {
    return storageTransitions.isNotEmpty;
  }

  void addTag(String key, String value) {
    tags[key] = value;
  }

  bool hasTags() {
    return tags.isNotEmpty;
  }

  bool hasNoncurrentVersionExpiration() {
    return noncurrentVersionExpiration != null;
  }

  bool hasNoncurrentVersionStorageTransitions() {
    return noncurrentVersionStorageTransitions.isNotEmpty;
  }
}

class StorageTransition {
  StorageTransition({
    this.expirationDays,
    this.createdBeforeDateTime,
    this.storageClass,
  });

  int? expirationDays;
  DateTime? createdBeforeDateTime;
  StorageClass? storageClass;

  bool hasCreatedBeforeDateTime() {
    return this.createdBeforeDateTime != null;
  }
}

class NoncurrentVersionStorageTransition {
  NoncurrentVersionStorageTransition({
    this.noncurrentDays,
    this.storageClass,
  });

  int? noncurrentDays;
  StorageClass? storageClass;

  bool hasNoncurrentDays() {
    return this.noncurrentDays != null;
  }
}

class NoncurrentVersionExpiration {
  NoncurrentVersionExpiration({
    this.noncurrentDays,
  });
  int? noncurrentDays;

  bool hasNoncurrentDays() {
    return this.noncurrentDays != null;
  }
}

class AbortMultipartUpload {
  int expirationDays;
  DateTime? createdBeforeDateTime;

  AbortMultipartUpload({
    this.expirationDays = 0,
    this.createdBeforeDateTime,
  });

  bool hasExpirationDays() {
    return expirationDays != 0;
  }

  bool hasCreatedBeforeDateTime() {
    return createdBeforeDateTime != null;
  }
}
