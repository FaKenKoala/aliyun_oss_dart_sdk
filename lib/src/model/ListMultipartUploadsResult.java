package com.alibaba.sdk.android.oss.model;

import android.util.Xml;

import com.alibaba.sdk.android.oss.common.utils.DateUtil;
import com.alibaba.sdk.android.oss.common.utils.OSSUtils;
import com.alibaba.sdk.android.oss.internal.ResponseMessage;

import org.xmlpull.v1.XmlPullParser;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by jingdan on 2018/2/13.
 */

 class ListMultipartUploadsResult extends OSSResult {

     String bucketName;

     String keyMarker;

     String delimiter;

     String prefix;

     String uploadIdMarker;

     int maxUploads;

     bool isTruncated;

     String nextKeyMarker;

     String nextUploadIdMarker;

     List<MultipartUpload> multipartUploads = new ArrayList<MultipartUpload>();

     List<String> commonPrefixes = new ArrayList<String>();

     String getBucketName() {
        return bucketName;
    }

     void setBucketName(String bucketName) {
        this.bucketName = bucketName;
    }

     String getKeyMarker() {
        return keyMarker;
    }

     void setKeyMarker(String keyMarker) {
        this.keyMarker = keyMarker;
    }

     String getUploadIdMarker() {
        return uploadIdMarker;
    }

     void setUploadIdMarker(String uploadIdMarker) {
        this.uploadIdMarker = uploadIdMarker;
    }

     String getNextKeyMarker() {
        return nextKeyMarker;
    }

     void setNextKeyMarker(String nextKeyMarker) {
        this.nextKeyMarker = nextKeyMarker;
    }

     String getNextUploadIdMarker() {
        return nextUploadIdMarker;
    }

     void setNextUploadIdMarker(String nextUploadIdMarker) {
        this.nextUploadIdMarker = nextUploadIdMarker;
    }

     int getMaxUploads() {
        return maxUploads;
    }

     void setMaxUploads(int maxUploads) {
        this.maxUploads = maxUploads;
    }

     bool isTruncated() {
        return isTruncated;
    }

     void setTruncated(bool isTruncated) {
        this.isTruncated = isTruncated;
    }

     List<MultipartUpload> getMultipartUploads() {
        return multipartUploads;
    }

     void setMultipartUploads(List<MultipartUpload> multipartUploads) {
        this.multipartUploads.clear();
        if (multipartUploads != null && !multipartUploads.isEmpty()) {
            this.multipartUploads.addAll(multipartUploads);
        }
    }

     void addMultipartUpload(MultipartUpload multipartUpload) {
        this.multipartUploads.add(multipartUpload);
    }

     String getDelimiter() {
        return delimiter;
    }

     void setDelimiter(String delimiter) {
        this.delimiter = delimiter;
    }

     String getPrefix() {
        return prefix;
    }

     void setPrefix(String prefix) {
        this.prefix = prefix;
    }

     List<String> getCommonPrefixes() {
        return commonPrefixes;
    }

     void setCommonPrefixes(List<String> commonPrefixes) {
        this.commonPrefixes.clear();
        if (commonPrefixes != null && !commonPrefixes.isEmpty()) {
            this.commonPrefixes.addAll(commonPrefixes);
        }
    }

     void addCommonPrefix(String commonPrefix) {
        this.commonPrefixes.add(commonPrefix);
    }

     ListMultipartUploadsResult parseData(ResponseMessage responseMessage) throws Exception {
        List<MultipartUpload> uploadList = new ArrayList<MultipartUpload>();
        MultipartUpload upload = null;
        bool isCommonPrefixes = false;
        XmlPullParser parser = Xml.newPullParser();
        parser.setInput(responseMessage.getContent(), "utf-8");
        int eventType = parser.getEventType();
        while (eventType != XmlPullParser.END_DOCUMENT) {
            switch (eventType) {
                case XmlPullParser.START_TAG:
                    String name = parser.getName();
                    if ("Bucket".equals(name)) {
                        setBucketName(parser.nextText());
                    } else if ("Delimiter".equals(name)) {
                        setDelimiter(parser.nextText());
                    } else if ("Prefix".equals(name)) {
                        if (isCommonPrefixes) {
                            String commonPrefix = parser.nextText();
                            if (!OSSUtils.isEmptyString(commonPrefix)) {
                                addCommonPrefix(commonPrefix);
                            }
                        } else {
                            setPrefix(parser.nextText());
                        }
                    } else if ("MaxUploads".equals(name)) {
                        String maxUploads = parser.nextText();
                        if (!OSSUtils.isEmptyString(maxUploads)) {
                            setMaxUploads(Integer.valueOf(maxUploads));
                        }
                    } else if ("IsTruncated".equals(name)) {
                        String isTruncated = parser.nextText();
                        if (!OSSUtils.isEmptyString(isTruncated)) {
                            setTruncated(bool.valueOf(isTruncated));
                        }
                    } else if ("KeyMarker".equals(name)) {
                        setKeyMarker(parser.nextText());
                    } else if ("UploadIdMarker".equals(name)) {
                        setUploadIdMarker(parser.nextText());
                    } else if ("NextKeyMarker".equals(name)) {
                        setNextKeyMarker(parser.nextText());
                    } else if ("NextUploadIdMarker".equals(name)) {
                        setNextUploadIdMarker(parser.nextText());
                    } else if ("Upload".equals(name)) {
                        upload = new MultipartUpload();
                    } else if ("Key".equals(name)) {
                        upload.setKey(parser.nextText());
                    } else if ("UploadId".equals(name)) {
                        upload.setUploadId(parser.nextText());
                    } else if ("Initiated".equals(name)) {
                        upload.setInitiated(DateUtil.parseIso8601Date(parser.nextText()));
                    } else if ("StorageClass".equals(name)) {
                        upload.setStorageClass(parser.nextText());
                    } else if ("CommonPrefixes".equals(name)) {
                        isCommonPrefixes = true;
                    }
                    break;
                case XmlPullParser.END_TAG:
                    if ("Upload".equals(parser.getName())) {
                        uploadList.add(upload);
                    } else if ("CommonPrefixes".equals(parser.getName())) {
                        isCommonPrefixes = false;
                    }
                    break;
            }

            eventType = parser.next();
            if (eventType == XmlPullParser.TEXT) {
                eventType = parser.next();
            }
        }

        if (uploadList.size() > 0) {
            setMultipartUploads(uploadList);
        }

        return this;
    }
}
