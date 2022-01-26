 import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/common/oss_headers.dart';
import 'package:aliyun_oss_dart_sdk/src/common/oss_log.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/extension_util.dart';
import 'package:aliyun_oss_dart_sdk/src/common/utils/oss_utils.dart';
import 'package:aliyun_oss_dart_sdk/src/exception/oss_ioexption.dart';
import 'package:aliyun_oss_dart_sdk/src/model/copy_object_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/delete_multiple_object_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/get_bucket_acl_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/get_bucket_info_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/get_bucket_lifecycle_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/get_bucket_logging_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/get_bucket_referer_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/initiate_multipart_upload_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/list_buckets_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/list_objects_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/list_parts_result.dart';
import 'package:aliyun_oss_dart_sdk/src/model/object_metadata.dart';
import 'package:aliyun_oss_dart_sdk/src/model/part_summary.dart';
import 'package:aliyun_oss_dart_sdk/src/model/put_object_result.dart';
import 'package:aliyun_oss_dart_sdk/src/service_exception.dart';

import 'http_message.dart';
import 'response_message.dart';

class ResponseParsers {

     static CopyObjectResult parseCopyObjectResponseXML(InputStream inStream, CopyObjectResult result)
             {

        XmlPullParser parser = Xml.newPullParser();
        parser.setI[in] = "utf-8";
        int eventType = parser.getEventType();
        while (eventType != XmlPullParser.END_DOCUMENT) {
            switch (eventType) {
                case XmlPullParser.START_TAG:
                    String name = parser.getName();
                    if ("LastModified".equals(name)) {
                        result.setLastModified(DateUtil.parseIso8601Date(parser.nextText()));
                    } else if ("ETag".equals(name)) {
                        result.setEtag(parser.nextText());
                    }
                    break;
            }

            eventType = parser.next();
            if (eventType == XmlPullParser.TEXT) {
                eventType = parser.next();
            }
        }
        return result;
    }

     static ListPartsResult parseListPartsResponseXML(InputStream inStream, ListPartsResult result)
             {

        List<PartSummary> partEtagList = [];
        PartSummary partSummary = null;
        XmlPullParser parser = Xml.newPullParser();
        parser.setI[in] = "utf-8";
        int eventType = parser.getEventType();
        while (eventType != XmlPullParser.END_DOCUMENT) {
            switch (eventType) {
                case XmlPullParser.START_TAG:
                    String name = parser.getName();
                    if ("Bucket".equals(name)) {
                        result.setBucketName(parser.nextText());
                    } else if ("Key".equals(name)) {
                        result.setKey(parser.nextText());
                    } else if ("UploadId".equals(name)) {
                        result.setUploadId(parser.nextText());
                    } else if ("PartNumberMarker".equals(name)) {
                        String partNumberMarker = parser.nextText();
                        if (!OSSUtils.isEmptyString(partNumberMarker)) {
                            result.setPartNumberMarker(Integer.parseInt(partNumberMarker));
                        }
                    } else if ("NextPartNumberMarker".equals(name)) {
                        String nextPartNumberMarker = parser.nextText();
                        if (!OSSUtils.isEmptyString(nextPartNumberMarker)) {
                            result.setNextPartNumberMarker(Integer.parseInt(nextPartNumberMarker));
                        }
                    } else if ("MaxParts".equals(name)) {
                        String maxParts = parser.nextText();
                        if (!OSSUtils.isEmptyString(maxParts)) {
                            result.setMaxParts(Integer.parseInt(maxParts));
                        }
                    } else if ("IsTruncated".equals(name)) {
                        String isTruncated = parser.nextText();
                        if (!OSSUtils.isEmptyString(isTruncated)) {
                            result.setTruncated(bool.valueOf(isTruncated));
                        }
                    } else if ("StorageClass".equals(name)) {
                        result.setStorageClass(parser.nextText());
                    } else if ("Part".equals(name)) {
                        partSummary = PartSummary();
                    } else if ("PartNumber".equals(name)) {
                        String partNum = parser.nextText();
                        if (!OSSUtils.isEmptyString(partNum)) {
                            partSummary.setPartNumber(Integer.valueOf(partNum));
                        }
                    } else if ("LastModified".equals(name)) {
                        partSummary.setLastModified(DateUtil.parseIso8601Date(parser.nextText()));
                    } else if ("ETag".equals(name)) {
                        partSummary.setETag(parser.nextText());
                    } else if ("Size".equals(name)) {
                        String size = parser.nextText();
                        if (!OSSUtils.isEmptyString(size)) {
                            partSummary.setSize(int.valueOf(size));
                        }
                    }
                    break;
                case XmlPullParser.END_TAG:
                    if ("Part".equals(parser.getName())) {
                        partEtagList.add(partSummary);
                    }
                    break;
            }
            eventType = parser.next();
            if (eventType == XmlPullParser.TEXT) {
                eventType = parser.next();
            }
        }

        if (partEtagList.size() > 0) {
            result.setParts(partEtagList);
        }

        return result;
    }

     static CompleteMultipartUploadResult parseCompleteMultipartUploadResponseXML(InputStream inStream, CompleteMultipartUploadResult result)
             {
        XmlPullParser parser = Xml.newPullParser();
        parser.setI[in] = "utf-8";
        int eventType = parser.getEventType();
        while (eventType != XmlPullParser.END_DOCUMENT) {
            switch (eventType) {
                case XmlPullParser.START_TAG:
                    String name = parser.getName();
                    if ("Location".equals(name)) {
                        result.setLocation(parser.nextText());
                    } else if ("Bucket".equals(name)) {
                        result.setBucketName(parser.nextText());
                    } else if ("Key".equals(name)) {
                        result.setObjectKey(parser.nextText());
                    } else if ("ETag".equals(name)) {
                        result.setETag(parser.nextText());
                    }
                    break;
            }

            eventType = parser.next();
            if (eventType == XmlPullParser.TEXT) {
                eventType = parser.next();
            }
        }

        return result;
    }

     static InitiateMultipartUploadResult parseInitMultipartResponseXML(InputStream inStream, InitiateMultipartUploadResult result)
             {
        XmlPullParser parser = Xml.newPullParser();
        parser.setI[in] = "utf-8";
        int eventType = parser.getEventType();
        while (eventType != XmlPullParser.END_DOCUMENT) {
            switch (eventType) {
                case XmlPullParser.START_TAG:
                    String name = parser.getName();
                    if ("Bucket".equals(name)) {
                        result.setBucketName(parser.nextText());
                    } else if ("Key".equals(name)) {
                        result.setObjectKey(parser.nextText());
                    } else if ("UploadId".equals(name)) {
                        result.setUploadId(parser.nextText());
                    }
                    break;
            }

            eventType = parser.next();
            if (eventType == XmlPullParser.TEXT) {
                eventType = parser.next();
            }
        }
        return result;
    }

    /// Parse the response of GetObjectACL
    ///
    /// @param in
    /// @param result
    /// @return
     static GetObjectACLResult parseGetObjectACLResponse(InputStream inStream, GetObjectACLResult result)
             {
        XmlPullParser parser = Xml.newPullParser();
        parser.setI[in] = "utf-8";
        int eventType = parser.getEventType();
        while (eventType != XmlPullParser.END_DOCUMENT) {
            switch (eventType) {
                case XmlPullParser.START_TAG:
                    String name = parser.getName();
                    if ("Grant".equals(name)) {
                        result.setObjectACL(parser.nextText());
                    } else if ("ID".equals(name)) {
                        result.setObjectOwnerID(parser.nextText());
                    } else if ("DisplayName".equals(name)) {
                        result.setObjectOwner(parser.nextText());
                    }
                    break;
            }

            eventType = parser.next();
            if (eventType == XmlPullParser.TEXT) {
                eventType = parser.next();
            }
        }
        return result;
    }

    /// Parse the response of GetBucketInfo
    ///
    /// @param in
    /// @return
    /// @throws Exception
     static GetBucketInfoResult parseGetBucketInfoResponse(InputStream inStream, GetBucketInfoResult result)
             {
        XmlPullParser parser = Xml.newPullParser();
        parser.setI[in] = "utf-8";
        int eventType = parser.getEventType();
        OSSBucketSummary bucket = null;
        Owner owner = null;
        while (eventType != XmlPullParser.END_DOCUMENT) {
            switch (eventType) {
                case XmlPullParser.START_TAG:
                    String name = parser.getName();
                    if (name == null) {
                        break;
                    }

                    if ("Owner".equals(name)) {
                        owner = Owner();
                    } else if ("ID".equals(name)) {
                        if (owner != null) {
                            owner.setId(parser.nextText());
                        }
                    } else if ("DisplayName".equals(name)) {
                        if (owner != null) {
                            owner.setDisplayName(parser.nextText());
                        }
                    } else if ("Bucket".equals(name)) {
                        bucket = OSSBucketSummary();
                    } else if ("CreationDate".equals(name)) {
                        if (bucket != null) {
                            bucket.createDate = DateUtil.parseIso8601Date(parser.nextText());
                        }
                    } else if ("ExtranetEndpoint".equals(name)) {
                        if (bucket != null) {
                            bucket.extranetEndpoint = parser.nextText();
                        }
                    } else if ("IntranetEndpoint".equals(name)) {
                        if (bucket != null) {
                            bucket.intranetEndpoint = parser.nextText();
                        }
                    } else if ("Location".equals(name)) {
                        if (bucket != null) {
                            bucket.location = parser.nextText();
                        }
                    } else if ("Name".equals(name)) {
                        if (bucket != null) {
                            bucket.name = parser.nextText();
                        }
                    } else if ("StorageClass".equals(name)) {
                        if (bucket != null) {
                            bucket.storageClass = parser.nextText();
                        }
                    } else if ("Grant".equals(name)) {
                        if (bucket != null) {
                            bucket.setAcl(parser.nextText());
                        }
                    }
                    break;
                case XmlPullParser.END_TAG:
                    String endTagName = parser.getName();
                    if (endTagName == null) {
                        break;
                    }

                    if ("Bucket".equals(endTagName)) {
                        if (bucket != null) {
                            result.setBucket(bucket);
                        }
                    } else if ("Owner".equals(endTagName)) {
                        if (bucket != null) {
                            bucket.owner = owner;
                        }
                    }

                    break;
            }
            eventType = parser.next();
            if (eventType == XmlPullParser.TEXT) {
                eventType = parser.next();
            }
        }
        return result;
    }

    /// Parse the response of GetBucketACL
     static GetBucketACLResult parseGetBucketACLResponse(InputStream inStream, GetBucketACLResult result)
             {
        XmlPullParser parser = Xml.newPullParser();
        parser.setI[in] = "utf-8";
        int eventType = parser.getEventType();
        while (eventType != XmlPullParser.END_DOCUMENT) {
            switch (eventType) {
                case XmlPullParser.START_TAG:
                    String name = parser.getName();
                    if ("Grant".equals(name)) {
                        result.setBucketACL(parser.nextText());
                    } else if ("ID".equals(name)) {
                        result.setBucketOwnerID(parser.nextText());
                    } else if ("DisplayName".equals(name)) {
                        result.setBucketOwner(parser.nextText());
                    }
                    break;
            }

            eventType = parser.next();
            if (eventType == XmlPullParser.TEXT) {
                eventType = parser.next();
            }
        }
        return result;
    }

     static GetBucketRefererResult parseGetBucketRefererResponse(InputStream inStream, GetBucketRefererResult result)  {
        XmlPullParser parser = Xml.newPullParser();
        parser.setI[in] = "utf-8";
        int eventType = parser.getEventType();
        while (eventType != XmlPullParser.END_DOCUMENT) {
            switch (eventType) {
                case XmlPullParser.START_TAG:
                    String name = parser.getName();
                    if ("Referer".equals(name)) {
                        result.addReferer(parser.nextText());
                    }
                    break;
            }

            eventType = parser.next();
            if (eventType == XmlPullParser.TEXT) {
                eventType = parser.next();
            }
        }
        return result;
    }

     static GetBucketLoggingResult parseGetBucketLoggingResponse(InputStream inStream, GetBucketLoggingResult result)  {
        XmlPullParser parser = Xml.newPullParser();
        parser.setI[in] = "utf-8";
        int eventType = parser.getEventType();
        while (eventType != XmlPullParser.END_DOCUMENT) {
            switch (eventType) {
                case XmlPullParser.START_TAG:
                    String name = parser.getName();
                    if ("LoggingEnabled".equals(name)) {
                        result.setLoggingEnabled(true);
                    } else if ("TargetBucket".equals(name)) {
                        result.setTargetBucketName(parser.nextText());
                    } else if ("TargetPrefix".equals(name)) {
                        result.setTargetPrefix(parser.nextText());
                    }

                    break;
            }

            eventType = parser.next();
            if (eventType == XmlPullParser.TEXT) {
                eventType = parser.next();
            }
        }
        return result;
    }

     static GetBucketLifecycleResult parseGetBucketLifecycleResponse(InputStream inStream, GetBucketLifecycleResult result)  {
        XmlPullParser parser = Xml.newPullParser();
        parser.setI[in] = "utf-8";
        int eventType = parser.getEventType();
        BucketLifecycleRule lifecycleRule = null;
        bool isExpirationConf = false;
        bool isMultipartConf = false;
        bool isTransitionConf = false;
        String daysValue = null;
        String dateValue = null;
        String storageClass = null;

        while (eventType != XmlPullParser.END_DOCUMENT) {
            switch (eventType) {
                case XmlPullParser.START_TAG:
                    String name = parser.getName();
                    if ("Rule".equals(name)) {
                        lifecycleRule = BucketLifecycleRule();
                    } else if ("ID".equals(name)) {
                        lifecycleRule.setIdentifier(parser.nextText());
                    } else if ("Prefix".equals(name)) {
                        lifecycleRule.setPrefix(parser.nextText());
                    } else if ("Status".equals(name)) {
                        String statusValue = parser.nextText();
                        if ("Enabled".equals(statusValue)) {
                            lifecycleRule.setStatus(true);
                        } else {
                            lifecycleRule.setStatus(false);
                        }
                    } else if ("Expiration".equals(name)) {
                        isExpirationConf = true;
                    } else if ("AbortMultipartUpload".equals(name)) {
                        isMultipartConf = true;
                    } else if ("Transition".equals(name)) {
                        isTransitionConf = true;
                    } else if ("Days".equals(name)) {
                        daysValue = parser.nextText();
                        if (lifecycleRule != null) {
                            if (isExpirationConf) {
                                lifecycleRule.setDays(daysValue);
                            } else if (isMultipartConf) {
                                lifecycleRule.setMultipartDays(daysValue);
                            } else if (isTransitionConf) {
                                if (storageClass != null) {
                                    if ("IA".equals(storageClass)) {
                                        lifecycleRule.setIADays(daysValue);
                                    } else if ("Archive".equals(storageClass)) {
                                        lifecycleRule.setArchiveDays(daysValue);
                                    }
                                }
                            }
                        }
                    }  else if ("Date".equals(name)) {
                        dateValue = parser.nextText();
                        if (lifecycleRule != null) {
                            if (isExpirationConf) {
                                lifecycleRule.setExpireDate(dateValue);
                            } else if (isMultipartConf) {
                                lifecycleRule.setMultipartExpireDate(dateValue);
                            } else if (isTransitionConf) {
                                if (storageClass != null) {
                                    if ("IA".equals(storageClass)) {
                                        lifecycleRule.setIAExpireDate(dateValue);
                                    } else if ("Archive".equals(storageClass)) {
                                        lifecycleRule.setArchiveExpireDate(dateValue);
                                    }
                                }
                            }
                        }
                    } else if ("StorageClass".equals(name)) {
                        storageClass = parser.nextText();
                        if (lifecycleRule != null) {
                            if ("IA".equals(storageClass)) {
                                lifecycleRule.setIADays(daysValue);
                                lifecycleRule.setIAExpireDate(dateValue);
                            } else if ("Archive".equals(storageClass)) {
                                lifecycleRule.setArchiveDays(dateValue);
                                lifecycleRule.setArchiveExpireDate(dateValue);
                            }
                        }
                    }
                    break;
                case XmlPullParser.END_TAG:
                    String endTag = parser.getName();
                    if ("Rule".equals(endTag)) {
                        result.addLifecycleRule(lifecycleRule);
                    } else if ("Expiration".equals(endTag)) {
                        isExpirationConf = false;
                    } else if ("AbortMultipartUpload".equals(endTag)) {
                        isMultipartConf = false;
                    } else if ("Transition".equals(endTag)) {
                        isTransitionConf = false;
                        daysValue = null;
                        dateValue = null;
                        storageClass = null;
                    }
                    break;
            }

            eventType = parser.next();
            if (eventType == XmlPullParser.TEXT) {
                eventType = parser.next();
            }
        }
        return result;
    }

     static DeleteMultipleObjectResult parseDeleteMultipleObjectResponse(InputStream inStream, DeleteMultipleObjectResult result)
             {
        XmlPullParser parser = Xml.newPullParser();
        parser.setI[in] = "utf-8";
        int eventType = parser.getEventType();
        while (eventType != XmlPullParser.END_DOCUMENT) {
            switch (eventType) {
                case XmlPullParser.START_TAG:
                    String name = parser.getName();
                    if ("Key".equals(name)) {
                        result.addDeletedObject(parser.nextText());
                    }
                    break;
            }

            eventType = parser.next();
            if (eventType == XmlPullParser.TEXT) {
                eventType = parser.next();
            }
        }
        return result;
    }

    /// Parse the response of listBucketInService
     static ListBucketsResult parseBucketListResponse(InputStream inStream, ListBucketsResult result)
             {
        result.clearBucketList();
        XmlPullParser parser = Xml.newPullParser();
        parser.setI[in] = "utf-8";
        int eventType = parser.getEventType();
        OSSBucketSummary bucket = null;
        while (eventType != XmlPullParser.END_DOCUMENT) {
            switch (eventType) {
                case XmlPullParser.START_TAG:
                    String name = parser.getName();
                    if (name == null) {
                        break;
                    }
                    if ("Prefix".equals(name)) {
                        result.setPrefix(parser.nextText());
                    } else if ("Marker".equals(name)) {
                        result.setMarker(parser.nextText());
                    } else if ("MaxKeys".equals(name)) {
                        String maxKeys = parser.nextText();
                        if (maxKeys != null) {
                            result.setMaxKeys(Integer.valueOf(maxKeys));
                        }
                    } else if ("IsTruncated".equals(name)) {
                        String isTruncated = parser.nextText();
                        if (isTruncated != null) {
                            result.setTruncated(bool.valueOf(isTruncated));
                        }
                    } else if ("NextMarker".equals(name)) {
                        result.setNextMarker(parser.nextText());
                    } else if ("ID".equals(name)) {
                        result.setOwnerId(parser.nextText());
                    } else if ("DisplayName".equals(name)) {
                        result.setOwnerDisplayName(parser.nextText());
                    } else if ("Bucket".equals(name)) {
                        bucket = OSSBucketSummary();
                    } else if ("CreationDate".equals(name)) {
                        if (bucket != null) {
                            bucket.createDate = DateUtil.parseIso8601Date(parser.nextText());
                        }
                    } else if ("ExtranetEndpoint".equals(name)) {
                        if (bucket != null) {
                            bucket.extranetEndpoint = parser.nextText();
                        }
                    } else if ("IntranetEndpoint".equals(name)) {
                        if (bucket != null) {
                            bucket.intranetEndpoint = parser.nextText();
                        }
                    } else if ("Location".equals(name)) {
                        if (bucket != null) {
                            bucket.location = parser.nextText();
                        }
                    } else if ("Name".equals(name)) {
                        if (bucket != null) {
                            bucket.name = parser.nextText();
                        }
                    } else if ("StorageClass".equals(name)) {
                        if (bucket != null) {
                            bucket.storageClass = parser.nextText();
                        }
                    }
                    break;
                case XmlPullParser.END_TAG:
                    String endTagName = parser.getName();
                    if ("Bucket".equals(endTagName)) {
                        if (bucket != null) {
                            result.addBucket(bucket);
                        }
                    }
                    break;
            }
            eventType = parser.next();
            if (eventType == XmlPullParser.TEXT) {
                eventType = parser.next();
            }
        }
        return result;
    }

    /// Parse the response of listObjectInBucket
     static ListObjectsResult parseObjectListResponse(InputStream inStream, ListObjectsResult result)
             {
        result.clearCommonPrefixes();
        result.clearObjectSummaries();
        XmlPullParser parser = Xml.newPullParser();
        parser.setI[in] = "utf-8";
        int eventType = parser.getEventType();
        OSSObjectSummary object = null;
        Owner owner = null;
        bool isCommonPrefixes = false;
        while (eventType != XmlPullParser.END_DOCUMENT) {
            switch (eventType) {
                case XmlPullParser.START_TAG:
                    String name = parser.getName();
                    if ("Name".equals(name)) {
                        result.setBucketName(parser.nextText());
                    } else if ("Prefix".equals(name)) {
                        if (isCommonPrefixes) {
                            String commonPrefix = parser.nextText();
                            if (!OSSUtils.isEmptyString(commonPrefix)) {
                                result.addCommonPrefix(commonPrefix);
                            }
                        } else {
                            result.setPrefix(parser.nextText());
                        }

                    } else if ("Marker".equals(name)) {
                        result.setMarker(parser.nextText());
                    } else if ("Delimiter".equals(name)) {
                        result.setDelimiter(parser.nextText());
                    } else if ("EncodingType".equals(name)) {
                        result.setEncodingType(parser.nextText());
                    } else if ("MaxKeys".equals(name)) {
                        String maxKeys = parser.nextText();
                        if (!OSSUtils.isEmptyString(maxKeys)) {
                            result.setMaxKeys(Integer.valueOf(maxKeys));
                        }
                    } else if ("NextMarker".equals(name)) {
                        result.setNextMarker(parser.nextText());
                    } else if ("IsTruncated".equals(name)) {
                        String isTruncated = parser.nextText();
                        if (!OSSUtils.isEmptyString(isTruncated)) {
                            result.setTruncated(bool.valueOf(isTruncated));
                        }
                    } else if ("Contents".equals(name)) {
                        object = OSSObjectSummary();
                    } else if ("Key".equals(name)) {
                        object.setKey(parser.nextText());
                    } else if ("LastModified".equals(name)) {
                        object.setLastModified(DateUtil.parseIso8601Date(parser.nextText()));
                    } else if ("Size".equals(name)) {
                        String size = parser.nextText();
                        if (!OSSUtils.isEmptyString(size)) {
                            object.setSize(int.valueOf(size));
                        }
                    } else if ("ETag".equals(name)) {
                        object.setETag(parser.nextText());
                    } else if ("Type".equals(name)) {
                        object.setType(parser.nextText());
                    } else if ("StorageClass".equals(name)) {
                        object.setStorageClass(parser.nextText());
                    } else if ("Owner".equals(name)) {
                        owner = Owner();
                    } else if ("ID".equals(name)) {
                        owner.setId(parser.nextText());
                    } else if ("DisplayName".equals(name)) {
                        owner.setDisplayName(parser.nextText());
                    } else if ("CommonPrefixes".equals(name)) {
                        isCommonPrefixes = true;
                    }
                    break;
                case XmlPullParser.END_TAG:
                    String endTagName = parser.getName();
                    if ("Owner".equals(parser.getName())) {
                        if (owner != null) {
                            object.setOwner(owner);
                        }
                    } else if ("Contents".equals(endTagName)) {
                        if (object != null) {
                            object.setBucketName(result.getBucketName());
                            result.addObjectSummary(object);
                        }
                    } else if ("CommonPrefixes".equals(endTagName)) {
                        isCommonPrefixes = false;
                    }
                    break;
            }

            eventType = parser.next();
            if (eventType == XmlPullParser.TEXT) {
                eventType = parser.next();
            }
        }

        return result;
    }

     static String trimQuotes(String s) {
        if (s == null) return null;

        s = s.trim();
        if (s.startsWith("\"")) s = s.substring(1);
        if (s.endsWith("\"")) s = s.substring(0, s.length() - 1);

        return s;
    }

    /// Unmarshall object metadata from response headers.
     static ObjectMetadata parseObjectMetadata(Map<String, String> headers)
             {

        try {
            ObjectMetadata objectMetadata = ObjectMetadata();

            for (Iterator<String> it = headers.keySet().iterator(); it.hasNext(); ) {
                String key = it.next();

                if (key.indexOf(OSSHeaders.OSS_USER_METADATA_PREFIX) >= 0) {
                    objectMetadata.addUserMetadata(key, headers.get(key));
                } else if (key.equalsIgnoreCase(OSSHeaders.LAST_MODIFIED) || key.equalsIgnoreCase(OSSHeaders.DATE)) {
                    try {
                        objectMetadata.setHeader(key, DateUtil.parseRfc822Date(headers.get(key)));
                    } catch (ParseException pe) {
                        throw OSSIOException(pe.getMessage(), pe);
                    }
                } else if (key.equalsIgnoreCase(OSSHeaders.CONTENT_LENGTH)) {
                    int value = int.valueOf(headers.get(key));
                    objectMetadata.setHeader(key, value);
                } else if (key.equalsIgnoreCase(OSSHeaders.ETAG)) {
                    objectMetadata.setHeader(key, trimQuotes(headers.get(key)));
                } else {
                    objectMetadata.setHeader(key, headers.get(key));
                }
            }

            return objectMetadata;
        } catch ( e) {
            throw OSSIOException(e.getMessage(), e);
        }
    }

     static Exception parseResponseErrorXML(ResponseMessage response, bool isHeadRequest) {

        int statusCode = response.getStatusCode();
        String requestId = response.getResponse().header(OSSHeaders.ossHeaderRequestId);
        String code = null;
        String message = null;
        String hostId = null;
        String partNumber = null;
        String partEtag = null;
        String errorMessage = null;
        if (!isHeadRequest) {
            try {
                errorMessage = response.getResponse().body().string();
                OSSLog.logDebug("errorMessage  ： " + " \n " +  errorMessage);
                InputStream inputStream = ByteArrayInputStream(errorMessage.getBytes());
                XmlPullParser parser = Xml.newPullParser();
                parser.setI[inputStream] = "utf-8";
                int eventType = parser.getEventType();
                while (eventType != XmlPullParser.END_DOCUMENT) {
                    switch (eventType) {
                        case XmlPullParser.START_TAG:
                            if ("Code".equals(parser.getName())) {
                                code = parser.nextText();
                            } else if ("Message".equals(parser.getName())) {
                                message = parser.nextText();
                            } else if ("RequestId".equals(parser.getName())) {
                                requestId = parser.nextText();
                            } else if ("HostId".equals(parser.getName())) {
                                hostId = parser.nextText();
                            } else if ("PartNumber".equals(parser.getName())) {
                                partNumber = parser.nextText();
                            } else if ("PartEtag".equals(parser.getName())) {
                                partEtag = parser.nextText();
                            }
                            break;
                    }
                    eventType = parser.next();
                    if (eventType == XmlPullParser.TEXT) {
                        eventType = parser.next();
                    }
                }
            } on OSSIOException catch ( e) {
                return OSSClientException(e.getMessage(), e);
            } catch (XmlPullParserException e) {
                return OSSClientException(e.getMessage(), e);
            }
        }

        OSSServiceException serviceException = OSSServiceException(statusCode, message, code, requestId, hostId, errorMessage);
        if (partEtag.notNullOrEmpty) {
            serviceException.partEtag =partEtag;
        }

        if (partNumber.notNullOrEmpty) {
            serviceException.partNumber = partNumber;
        }


        return serviceException;
    }
}

     class PutObjectResponseParser extends AbstractResponseParser<PutObjectResult> {

        @override
         PutObjectResult parseData(ResponseMessage response, PutObjectResult result)
                 {
            result.setETag(trimQuotes(response.getHeaders().get(OSSHeaders.ETAG)));
            String body = response.getResponse().body().string();
            if (body).notNullOrEmpty {
                result.setServerCallbackReturnBody(body);
            }
            return result;
        }
    }

     class AppendObjectResponseParser extends AbstractResponseParser<AppendObjectResult> {

        @override
         AppendObjectResult parseData(ResponseMessage response, AppendObjectResult result)  {
            String nextPosition = response.getHeaders().get(OSSHeaders.OSS_NEXT_APPEND_POSITION);
            if (nextPosition != null) {
                result.setNextPosition(int.valueOf(nextPosition));
            }
            result.setObjectCRC64(response.getHeaders().get(OSSHeaders.OSS_HASH_CRC64_ECMA));
            return result;
        }
    }

     class HeadObjectResponseParser extends AbstractResponseParser<HeadObjectResult> {

        @override
         HeadObjectResult parseData(ResponseMessage response, HeadObjectResult result)  {
            result.setMetadata(parseObjectMetadata(result.getResponseHeader()));
            return result;
        }
    }

     class GetObjectResponseParser extends AbstractResponseParser<GetObjectResult> {

        @override
         GetObjectResult parseData(ResponseMessage response, GetObjectResult result)  {
            result.setMetadata(parseObjectMetadata(result.getResponseHeader()));
            result.setContentLength(response.getContentLength());
            if (response.getRequest().isCheckCRC64()) {
                result.setObjectContent(CheckCRC64DownloadInputStream(response.getContent()
                        , CRC64(), response.getContentLength()
                        , result.getServerCRC(), result.getRequestId()));
            } else {
                result.setObjectContent(response.getContent());
            }
            return result;
        }

        @override
         bool needCloseResponse() {
            // keep body stream open for reading content
            return false;
        }
    }

     class GetObjectACLResponseParser extends AbstractResponseParser<GetObjectACLResult> {

        @override
        GetObjectACLResult parseData(ResponseMessage response, GetObjectACLResult result)  {
            result = parseGetObjectACLResponse(response.getContent(), result);
            return result;
        }
    }

     class CopyObjectResponseParser extends AbstractResponseParser<CopyObjectResult> {

        @override
         CopyObjectResult parseData(ResponseMessage response, CopyObjectResult result)  {
            result = parseCopyObjectResponseXML(response.getContent(), result);
            return result;
        }
    }

     class CreateBucketResponseParser extends AbstractResponseParser<CreateBucketResult> {

        @override
         CreateBucketResult parseData(ResponseMessage response, CreateBucketResult result)  {
            if (result.getResponseHeader().containsKey("Location")) {
                result.bucketLocation = result.getResponseHeader().get("Location");
            }
            return result;
        }
    }

     class DeleteBucketResponseParser extends AbstractResponseParser<DeleteBucketResult> {

        @override
         DeleteBucketResult parseData(ResponseMessage response, DeleteBucketResult result)  {
            return result;
        }
    }

     class GetBucketInfoResponseParser extends AbstractResponseParser<GetBucketInfoResult> {

        @override
         GetBucketInfoResult parseData(ResponseMessage response, GetBucketInfoResult result)  {
            result = parseGetBucketInfoResponse(response.getContent(), result);
            return result;
        }
    }

     class GetBucketACLResponseParser extends AbstractResponseParser<GetBucketACLResult> {

        @override
         GetBucketACLResult parseData(ResponseMessage response, GetBucketACLResult result)  {
            result = parseGetBucketACLResponse(response.getContent(), result);
            return result;
        }
    }

     class PutBucketRefererResponseParser extends AbstractResponseParser<PutBucketRefererResult> {

        @override
         PutBucketRefererResult parseData(ResponseMessage response, PutBucketRefererResult result)  {
            return result;
        }
    }

     class GetBucketRefererResponseParser extends AbstractResponseParser<GetBucketRefererResult> {

        @override
         GetBucketRefererResult parseData(ResponseMessage response, GetBucketRefererResult result)  {
            result = parseGetBucketRefererResponse(response.getContent(), result);
            return result;
        }
    }

     class PutBucketLoggingResponseParser extends AbstractResponseParser<PutBucketLoggingResult> {

        @override
         PutBucketLoggingResult parseData(ResponseMessage response, PutBucketLoggingResult result)  {
            return result;
        }
    }

     class GetBucketLoggingResponseParser extends AbstractResponseParser<GetBucketLoggingResult> {

        @override
         GetBucketLoggingResult parseData(ResponseMessage response, GetBucketLoggingResult result)  {
            result = parseGetBucketLoggingResponse(response.getContent(), result);
            return result;
        }
    }

     class DeleteBucketLoggingResponseParser extends AbstractResponseParser<DeleteBucketLoggingResult> {

        @override
         DeleteBucketLoggingResult parseData(ResponseMessage response, DeleteBucketLoggingResult result)  {
            return result;
        }
    }

     class PutBucketLifecycleResponseParser extends AbstractResponseParser<PutBucketLifecycleResult> {

        @override
         PutBucketLifecycleResult parseData(ResponseMessage response, PutBucketLifecycleResult result)  {
            return result;
        }
    }

     class GetBucketLifecycleResponseParser extends AbstractResponseParser<GetBucketLifecycleResult> {

        @override
         GetBucketLifecycleResult parseData(ResponseMessage response, GetBucketLifecycleResult result)  {
            result = parseGetBucketLifecycleResponse(response.getContent(), result);
            return result;
        }
    }

     class DeleteBucketLifecycleResponseParser extends AbstractResponseParser<DeleteBucketLifecycleResult> {

        @override
         DeleteBucketLifecycleResult parseData(ResponseMessage response, DeleteBucketLifecycleResult result)  {
            return result;
        }
    }

     class DeleteObjectResponseParser extends AbstractResponseParser<DeleteObjectResult> {

        @override
         DeleteObjectResult parseData(ResponseMessage response, DeleteObjectResult result)  {
            return result;
        }
    }

     class DeleteMultipleObjectResponseParser extends AbstractResponseParser<DeleteMultipleObjectResult> {

        @override
        DeleteMultipleObjectResult parseData(ResponseMessage response, DeleteMultipleObjectResult result)  {
            result = parseDeleteMultipleObjectResponse(response.getContent(), result);
            return result;
        }
    }

     class ListObjectsResponseParser extends AbstractResponseParser<ListObjectsResult> {

        @override
         ListObjectsResult parseData(ResponseMessage response, ListObjectsResult result)  {
            result = parseObjectListResponse(response.getContent(), result);
            return result;
        }
    }

     class ListBucketResponseParser extends AbstractResponseParser<ListBucketsResult> {

        @override
        ListBucketsResult parseData(ResponseMessage response, ListBucketsResult result)  {
            result = parseBucketListResponse(response.getContent(), result);
            return result;
        }
    }

     class InitMultipartResponseParser extends AbstractResponseParser<InitiateMultipartUploadResult> {

        @override
         InitiateMultipartUploadResult parseData(ResponseMessage response, InitiateMultipartUploadResult result)  {
            return parseInitMultipartResponseXML(response.getContent(), result);
        }
    }

     class UploadPartResponseParser extends AbstractResponseParser<UploadPartResult> {

        @override
         UploadPartResult parseData(ResponseMessage response, UploadPartResult result)  {
            result.setETag(trimQuotes(response.getHeaders().get(OSSHeaders.ETAG)));
            return result;
        }
    }

     class AbortMultipartUploadResponseParser extends AbstractResponseParser<AbortMultipartUploadResult> {

        @override
         AbortMultipartUploadResult parseData(ResponseMessage response, AbortMultipartUploadResult result)  {
            return result;
        }
    }

     class CompleteMultipartUploadResponseParser extends AbstractResponseParser<CompleteMultipartUploadResult> {

        @override
         CompleteMultipartUploadResult parseData(ResponseMessage response, CompleteMultipartUploadResult result)  {
            if (response.getHeaders().get(OSSHeaders.CONTENT_TYPE).equals("application/xml")) {
                result = parseCompleteMultipartUploadResponseXML(response.getContent(), result);
            } else {
                String body = response.getResponse().body().string();
                if (body).notNullOrEmpty {
                    result.setServerCallbackReturnBody(body);
                }
            }
            return result;
        }
    }

     class ListPartsResponseParser extends AbstractResponseParser<ListPartsResult> {

        @override
         ListPartsResult parseData(ResponseMessage response, ListPartsResult result)  {
            result = parseListPartsResponseXML(response.getContent(), result);
            return result;
        }
    }

     class ListMultipartUploadsResponseParser extends AbstractResponseParser<ListMultipartUploadsResult> {

        @override
         ListMultipartUploadsResult parseData(ResponseMessage response, ListMultipartUploadsResult result)  {
            return result.parseData(response);
        }
    }

     class TriggerCallbackResponseParser extends AbstractResponseParser<TriggerCallbackResult> {

        @override
         TriggerCallbackResult parseData(ResponseMessage response, TriggerCallbackResult result)  {
            String body = response.getResponse().body().string();
            if (body).notNullOrEmpty {
                result.setServerCallbackReturnBody(body);
            }
            return result;
        }
    }

     class ImagePersistResponseParser extends AbstractResponseParser<ImagePersistResult> {

        @override
         ImagePersistResult parseData(ResponseMessage response, ImagePersistResult result)  {
            return result;
        }
    }

     class PutSymlinkResponseParser extends AbstractResponseParser<PutSymlinkResult> {

        @override
        PutSymlinkResult parseData(ResponseMessage response, PutSymlinkResult result)  {
            return result;
        }
    }

     class GetSymlinkResponseParser extends AbstractResponseParser<GetSymlinkResult> {

        @override
        GetSymlinkResult parseData(ResponseMessage response, GetSymlinkResult result)  {
            result.setTargetObjectName(response.getHeaders().get(OSSHeaders.OSS_HEADER_SYMLINK_TARGET));
            return result;
        }
    }

     class RestoreObjectResponseParser extends AbstractResponseParser<RestoreObjectResult> {

        @override
        RestoreObjectResult parseData(ResponseMessage response, RestoreObjectResult result)  {
            return result;
        }
    }

