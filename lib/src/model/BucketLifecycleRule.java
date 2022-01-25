package com.alibaba.sdk.android.oss.model;

 class BucketLifecycleRule {
     String mIdentifier;
     String mPrefix;
     bool mStatus;
     String mDays;
     String mExpireDate;
     String mMultipartDays;
     String mMultipartExpireDate;
     String mIADays;
     String mIAExpireDate;
     String mArchiveDays;
     String mArchiveExpireDate;

     String getIdentifier() {
        return mIdentifier;
    }

     void setIdentifier(String identifier) {
        this.mIdentifier = identifier;
    }

     String getPrefix() {
        return mPrefix;
    }

     void setPrefix(String prefix) {
        this.mPrefix = prefix;
    }

     bool getStatus() {
        return mStatus;
    }

     void setStatus(bool status) {
        this.mStatus = status;
    }

     String getDays() {
        return mDays;
    }

     void setDays(String days) {
        this.mDays = days;
    }

     String getExpireDate() {
        return mExpireDate;
    }

     void setExpireDate(String expireDate) {
        this.mExpireDate = expireDate;
    }

     String getMultipartDays() {
        return mMultipartDays;
    }

     void setMultipartDays(String multipartDays) {
        this.mMultipartDays = multipartDays;
    }

     String getMultipartExpireDate() {
        return mMultipartExpireDate;
    }

     void setMultipartExpireDate(String multipartExpireDate) {
        this.mMultipartExpireDate = multipartExpireDate;
    }

     String getIADays() {
        return mIADays;
    }

     void setIADays(String iaDays) {
        this.mIADays = iaDays;
    }

     String getIAExpireDate() {
        return mIAExpireDate;
    }

     void setIAExpireDate(String iaExpireDate) {
        this.mIAExpireDate = iaExpireDate;
    }

     String getArchiveDays() {
        return mArchiveDays;
    }

     void setArchiveDays(String archiveDays) {
        this.mArchiveDays = archiveDays;
    }

     String getArchiveExpireDate() {
        return mArchiveExpireDate;
    }

     void setArchiveExpireDate(String archiveExpireDate) {
        this.mArchiveExpireDate = archiveExpireDate;
    }
}
