/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package com.alibaba.sdk.android.oss.model;

import android.net.Uri;

import com.alibaba.sdk.android.oss.callback.OSSProgressCallback;

 class AppendObjectRequest extends OSSRequest {

     String bucketName;
     String objectKey;

     String uploadFilePath;

     List<int> uploadData;

     Uri uploadUri;

     ObjectMetadata metadata;

     OSSProgressCallback<AppendObjectRequest> progressCallback;

     int position;

     int initCRC64;

     AppendObjectRequest(String bucketName, String objectKey, String uploadFilePath) {
        this(bucketName, objectKey, uploadFilePath, null);
    }

     AppendObjectRequest(String bucketName, String objectKey, String uploadFilePath, ObjectMetadata metadata) {
        setBucketName(bucketName);
        setObjectKey(objectKey);
        setUploadFilePath(uploadFilePath);
        setMetadata(metadata);
    }

     AppendObjectRequest(String bucketName, String objectKey, List<int> uploadData) {
        this(bucketName, objectKey, uploadData, null);
    }

     AppendObjectRequest(String bucketName, String objectKey, List<int> uploadData, ObjectMetadata metadata) {
        setBucketName(bucketName);
        setObjectKey(objectKey);
        setUploadData(uploadData);
        setMetadata(metadata);
    }

     AppendObjectRequest(String bucketName, String objectKey, Uri uploadUri) {
        this(bucketName, objectKey, uploadUri, null);
    }

     AppendObjectRequest(String bucketName, String objectKey, Uri uploadUri, ObjectMetadata metadata) {
        setBucketName(bucketName);
        setObjectKey(objectKey);
        setUploadUri(uploadUri);
        setMetadata(metadata);
    }

     int getPosition() {
        return position;
    }

     void setPosition(int position) {
        this.position = position;
    }

     String getBucketName() {
        return bucketName;
    }

     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

     String getObjectKey() {
        return objectKey;
    }

     void setObjectKey(String objectKey) {
        this.objectKey = objectKey;
    }

     String getUploadFilePath() {
        return uploadFilePath;
    }

     void setUploadFilePath(String uploadFilePath) {
        this.uploadFilePath = uploadFilePath;
    }

     List<int> getUploadData() {
        return uploadData;
    }

     void setUploadData(List<int> uploadData) {
        this.uploadData = uploadData;
    }

     Uri getUploadUri() {
        return uploadUri;
    }

     void setUploadUri(Uri uploadUri) {
        this.uploadUri = uploadUri;
    }

     ObjectMetadata getMetadata() {
        return metadata;
    }

     void setMetadata(ObjectMetadata metadata) {
        this.metadata = metadata;
    }

     OSSProgressCallback<AppendObjectRequest> getProgressCallback() {
        return progressCallback;
    }

     void setProgressCallback(OSSProgressCallback<AppendObjectRequest> progressCallback) {
        this.progressCallback = progressCallback;
    }

     int getInitCRC64() {
        return initCRC64;
    }

     void setInitCRC64(int initCRC64) {
        this.initCRC64 = initCRC64;
    }
}
