import 'dart:convert';

import 'package:aliyun_oss_dart_sdk/src/client_exception.dart';
import 'package:aliyun_oss_dart_sdk/src/common/lib_common.dart';
import 'package:aliyun_oss_dart_sdk/src/exception/oss_ioexception.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/lib_internal.dart';
import 'package:aliyun_oss_dart_sdk/src/model/lib_model.dart';
import 'package:aliyun_oss_dart_sdk/src/service_exception.dart';

CopyObjectResult parseCopyObjectResponseXML(
    InputStream? inStream, CopyObjectResult result) {
  XmlPullParser parser = Xml.newPullParser();
  parser.setInput(inStream, "utf-8");
  int eventType = parser.getEventType();
  while (eventType != XmlPullParser.END_DOCUMENT) {
    switch (eventType) {
      case XmlPullParser.START_TAG:
        String? name = parser.getName();
        if ("LastModified" == name) {
          result.lastModified = DateUtil.parseIso8601Date(parser.nextText());
        } else if ("ETag" == name) {
          result.eTag = parser.nextText();
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

ListPartsResult parseListPartsResponseXML(
    InputStream? inStream, ListPartsResult result) {
  List<PartSummary> partEtagList = [];
  PartSummary? partSummary;
  XmlPullParser parser = Xml.newPullParser();
  parser.setInput(inStream, "utf-8");
  int eventType = parser.getEventType();
  while (eventType != XmlPullParser.END_DOCUMENT) {
    switch (eventType) {
      case XmlPullParser.START_TAG:
        String? name = parser.getName();
        if ("Bucket" == name) {
          result.bucketName = parser.nextText();
        } else if ("Key" == name) {
          result.key = parser.nextText();
        } else if ("UploadId" == name) {
          result.uploadId = parser.nextText();
        } else if ("PartNumberMarker" == name) {
          String? partNumberMarker = parser.nextText();
          if (partNumberMarker.notNullOrEmpty) {
            result.partNumberMarker = int.parse(partNumberMarker!);
          }
        } else if ("NextPartNumberMarker" == name) {
          String? nextPartNumberMarker = parser.nextText();
          if (nextPartNumberMarker.notNullOrEmpty) {
            result.nextPartNumberMarker = int.parse(nextPartNumberMarker!);
          }
        } else if ("MaxParts" == name) {
          String? maxParts = parser.nextText();
          if (maxParts.notNullOrEmpty) {
            result.maxParts = int.parse(maxParts!);
          }
        } else if ("IsTruncated" == name) {
          String? isTruncated = parser.nextText();
          if (isTruncated.notNullOrEmpty) {
            result.isTruncated = isTruncated!.toLowerCase() == 'true';
          }
        } else if ("StorageClass" == name) {
          result.storageClass = parser.nextText();
        } else if ("Part" == name) {
          partSummary = PartSummary();
        } else if ("PartNumber" == name) {
          String? partNum = parser.nextText();
          if (partNum.notNullOrEmpty) {
            partSummary?.partNumber = int.parse(partNum!);
          }
        } else if ("LastModified" == name) {
          partSummary?.lastModified = DateUtil.parseIso8601Date(parser.nextText());
        } else if ("ETag" == name) {
          partSummary?.eTag = parser.nextText();
        } else if ("Size" == name) {
          String? size = parser.nextText();
          if (size.notNullOrEmpty) {
            partSummary?.size = int.parse(size!);
          }
        }
        break;
      case XmlPullParser.END_TAG:
        if ("Part" == parser.getName()) {
          partEtagList.add(partSummary!);
        }
        break;
    }
    eventType = parser.next();
    if (eventType == XmlPullParser.TEXT) {
      eventType = parser.next();
    }
  }

  if (partEtagList.isNotEmpty) {
    result.setParts(partEtagList);
  }

  return result;
}

CompleteMultipartUploadResult parseCompleteMultipartUploadResponseXML(
    InputStream? inStream, CompleteMultipartUploadResult result) {
  XmlPullParser parser = Xml.newPullParser();
  parser.setInput(inStream, "utf-8");
  int eventType = parser.getEventType();
  while (eventType != XmlPullParser.END_DOCUMENT) {
    switch (eventType) {
      case XmlPullParser.START_TAG:
        String? name = parser.getName();
        if ("Location" == name) {
          result.location = parser.nextText();
        } else if ("Bucket" == name) {
          result.bucketName = parser.nextText();
        } else if ("Key" == name) {
          result.objectKey = parser.nextText();
        } else if ("ETag" == name) {
          result.eTag = parser.nextText();
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

InitiateMultipartUploadResult parseInitMultipartResponseXML(
    InputStream? inStream, InitiateMultipartUploadResult result) {
  XmlPullParser parser = Xml.newPullParser();
  parser.setInput(inStream, "utf-8");
  int eventType = parser.getEventType();
  while (eventType != XmlPullParser.END_DOCUMENT) {
    switch (eventType) {
      case XmlPullParser.START_TAG:
        String? name = parser.getName();
        if ("Bucket" == name) {
          result.bucketName = parser.nextText();
        } else if ("Key" == name) {
          result.objectKey = parser.nextText();
        } else if ("UploadId" == name) {
          result.uploadId = parser.nextText();
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
GetObjectACLResult parseGetObjectACLResponse(
    InputStream? inStream, GetObjectACLResult result) {
  XmlPullParser parser = Xml.newPullParser();
  parser.setInput(inStream, "utf-8");
  int eventType = parser.getEventType();
  while (eventType != XmlPullParser.END_DOCUMENT) {
    switch (eventType) {
      case XmlPullParser.START_TAG:
        String? name = parser.getName();
        if ("Grant" == name) {
          result.objectACL = parser.nextText();
        } else if ("ID" == name) {
          result.objectOwnerID = parser.nextText();
        } else if ("DisplayName" == name) {
          result.objectOwner = parser.nextText();
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
GetBucketInfoResult parseGetBucketInfoResponse(
    InputStream? inStream, GetBucketInfoResult result) {
  XmlPullParser parser = Xml.newPullParser();
  parser.setInput(inStream, "utf-8");
  int eventType = parser.getEventType();
  OSSBucketSummary? bucket;
  Owner? owner;
  while (eventType != XmlPullParser.END_DOCUMENT) {
    switch (eventType) {
      case XmlPullParser.START_TAG:
        String? name = parser.getName();
        if (name == null) {
          break;
        }

        if ("Owner" == name) {
          owner = Owner();
        } else if ("ID" == name) {
          owner?.id = parser.nextText();
        } else if ("DisplayName" == name) {
          owner?.displayName = parser.nextText();
        } else if ("Bucket" == name) {
          bucket = OSSBucketSummary();
        } else if ("CreationDate" == name) {
          bucket?.createDate = DateUtil.parseIso8601Date(parser.nextText());
        } else if ("ExtranetEndpoint" == name) {
          bucket?.extranetEndpoint = parser.nextText();
        } else if ("IntranetEndpoint" == name) {
          bucket?.intranetEndpoint = parser.nextText();
        } else if ("Location" == name) {
          bucket?.location = parser.nextText();
        } else if ("Name" == name) {
          bucket?.name = parser.nextText();
        } else if ("StorageClass" == name) {
          bucket?.storageClass = parser.nextText();
        } else if ("Grant" == name) {
          bucket?.setAcl(parser.nextText());
        }
        break;
      case XmlPullParser.END_TAG:
        String? endTagName = parser.getName();
        if (endTagName == null) {
          break;
        }

        if ("Bucket" == endTagName) {
          if (bucket != null) {
            result.bucket = bucket;
          }
        } else if ("Owner" == endTagName) {
          bucket?.owner = owner;
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
GetBucketACLResult parseGetBucketACLResponse(
    InputStream? inStream, GetBucketACLResult result) {
  XmlPullParser parser = Xml.newPullParser();
  parser.setInput(inStream, "utf-8");
  int eventType = parser.getEventType();
  while (eventType != XmlPullParser.END_DOCUMENT) {
    switch (eventType) {
      case XmlPullParser.START_TAG:
        String? name = parser.getName();
        if ("Grant" == name) {
          result.bucketACL = parser.nextText();
        } else if ("ID" == name) {
          result.setBucketOwnerID(parser.nextText());
        } else if ("DisplayName" == name) {
          result.bucketOwner = parser.nextText();
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

GetBucketRefererResult parseGetBucketRefererResponse(
    InputStream? inStream, GetBucketRefererResult result) {
  XmlPullParser parser = Xml.newPullParser();
  parser.setInput(inStream, "utf-8");
  int eventType = parser.getEventType();
  while (eventType != XmlPullParser.END_DOCUMENT) {
    switch (eventType) {
      case XmlPullParser.START_TAG:
        String? name = parser.getName();
        if ("Referer" == name) {
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

GetBucketLoggingResult parseGetBucketLoggingResponse(
    InputStream? inStream, GetBucketLoggingResult result) {
  XmlPullParser parser = Xml.newPullParser();
  parser.setInput(inStream, "utf-8");
  int eventType = parser.getEventType();
  while (eventType != XmlPullParser.END_DOCUMENT) {
    switch (eventType) {
      case XmlPullParser.START_TAG:
        String? name = parser.getName();
        if ("LoggingEnabled" == name) {
          result.loggingEnabled = true;
        } else if ("TargetBucket" == name) {
          result.targetBucketName = parser.nextText();
        } else if ("TargetPrefix" == name) {
          result.targetPrefix = parser.nextText();
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

GetBucketLifecycleResult parseGetBucketLifecycleResponse(
    InputStream? inStream, GetBucketLifecycleResult result) {
  XmlPullParser parser = Xml.newPullParser();
  parser.setInput(inStream, "utf-8");
  int eventType = parser.getEventType();
  BucketLifecycleRule? lifecycleRule;
  bool isExpirationConf = false;
  bool isMultipartConf = false;
  bool isTransitionConf = false;
  String? daysValue;
  String? dateValue;
  String? storageClass;

  while (eventType != XmlPullParser.END_DOCUMENT) {
    switch (eventType) {
      case XmlPullParser.START_TAG:
        String? name = parser.getName();
        if ("Rule" == name) {
          lifecycleRule = BucketLifecycleRule();
        } else if ("ID" == name) {
          lifecycleRule?.identifier = parser.nextText();
        } else if ("Prefix" == name) {
          lifecycleRule?.prefix = parser.nextText();
        } else if ("Status" == name) {
          String? statusValue = parser.nextText();
          if ("Enabled" == statusValue) {
            lifecycleRule?.status = true;
          } else {
            lifecycleRule?.status = false;
          }
        } else if ("Expiration" == name) {
          isExpirationConf = true;
        } else if ("AbortMultipartUpload" == name) {
          isMultipartConf = true;
        } else if ("Transition" == name) {
          isTransitionConf = true;
        } else if ("Days" == name) {
          daysValue = parser.nextText();
          if (lifecycleRule != null) {
            if (isExpirationConf) {
              lifecycleRule.days = daysValue;
            } else if (isMultipartConf) {
              lifecycleRule.multipartDays = daysValue;
            } else if (isTransitionConf) {
              if (storageClass != null) {
                if ("IA" == storageClass) {
                  lifecycleRule.iADays = daysValue;
                } else if ("Archive" == storageClass) {
                  lifecycleRule.archiveDays = daysValue;
                }
              }
            }
          }
        } else if ("Date" == name) {
          dateValue = parser.nextText();
          if (lifecycleRule != null) {
            if (isExpirationConf) {
              lifecycleRule.expireDate = dateValue;
            } else if (isMultipartConf) {
              lifecycleRule.multipartExpireDate = dateValue;
            } else if (isTransitionConf) {
              if (storageClass != null) {
                if ("IA" == storageClass) {
                  lifecycleRule.iAExpireDate = dateValue;
                } else if ("Archive" == storageClass) {
                  lifecycleRule.archiveExpireDate = dateValue;
                }
              }
            }
          }
        } else if ("StorageClass" == name) {
          storageClass = parser.nextText();
          if (lifecycleRule != null) {
            if ("IA" == storageClass) {
              lifecycleRule.iADays = daysValue;
              lifecycleRule.iAExpireDate = dateValue;
            } else if ("Archive" == storageClass) {
              lifecycleRule.archiveDays = dateValue;
              lifecycleRule.archiveExpireDate = dateValue;
            }
          }
        }
        break;
      case XmlPullParser.END_TAG:
        String? endTag = parser.getName();
        if ("Rule" == endTag) {
          result.addLifecycleRule(lifecycleRule);
        } else if ("Expiration" == endTag) {
          isExpirationConf = false;
        } else if ("AbortMultipartUpload" == endTag) {
          isMultipartConf = false;
        } else if ("Transition" == endTag) {
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

DeleteMultipleObjectResult parseDeleteMultipleObjectResponse(
    InputStream? inStream, DeleteMultipleObjectResult result) {
  XmlPullParser parser = Xml.newPullParser();
  parser.setInput(inStream, "utf-8");
  int eventType = parser.getEventType();
  while (eventType != XmlPullParser.END_DOCUMENT) {
    switch (eventType) {
      case XmlPullParser.START_TAG:
        String? name = parser.getName();
        if ("Key" == name) {
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
ListBucketsResult parseBucketListResponse(
    InputStream? inStream, ListBucketsResult result) {
  result.clearBucketList();
  XmlPullParser parser = Xml.newPullParser();
  parser.setInput(inStream, "utf-8");
  int eventType = parser.getEventType();
  OSSBucketSummary? bucket;
  while (eventType != XmlPullParser.END_DOCUMENT) {
    switch (eventType) {
      case XmlPullParser.START_TAG:
        String? name = parser.getName();
        if (name == null) {
          break;
        }
        if ("Prefix" == name) {
          result.prefix = parser.nextText();
        } else if ("Marker" == name) {
          result.marker = parser.nextText();
        } else if ("MaxKeys" == name) {
          String? maxKeys = parser.nextText();
          if (maxKeys != null) {
            result.maxKeys = int.parse(maxKeys);
          }
        } else if ("IsTruncated" == name) {
          String? isTruncated = parser.nextText();
          if (isTruncated != null) {
            result.isTruncated = isTruncated.toLowerCase() == 'true';
          }
        } else if ("NextMarker" == name) {
          result.nextMarker = parser.nextText();
        } else if ("ID" == name) {
          result.ownerId = parser.nextText();
        } else if ("DisplayName" == name) {
          result.ownerDisplayName = parser.nextText();
        } else if ("Bucket" == name) {
          bucket = OSSBucketSummary();
        } else if ("CreationDate" == name) {
          if (bucket != null) {
            bucket.createDate = DateUtil.parseIso8601Date(parser.nextText());
          }
        } else if ("ExtranetEndpoint" == name) {
          if (bucket != null) {
            bucket.extranetEndpoint = parser.nextText();
          }
        } else if ("IntranetEndpoint" == name) {
          if (bucket != null) {
            bucket.intranetEndpoint = parser.nextText();
          }
        } else if ("Location" == name) {
          if (bucket != null) {
            bucket.location = parser.nextText();
          }
        } else if ("Name" == name) {
          if (bucket != null) {
            bucket.name = parser.nextText();
          }
        } else if ("StorageClass" == name) {
          if (bucket != null) {
            bucket.storageClass = parser.nextText();
          }
        }
        break;
      case XmlPullParser.END_TAG:
        String? endTagName = parser.getName();
        if ("Bucket" == endTagName) {
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
ListObjectsResult parseObjectListResponse(
    InputStream? inStream, ListObjectsResult result) {
  result.clearCommonPrefixes();
  result.clearObjectSummaries();
  XmlPullParser parser = Xml.newPullParser();
  parser.setInput(inStream, "utf-8");
  int eventType = parser.getEventType();
  late OSSObjectSummary object;
  Owner? owner;
  bool isCommonPrefixes = false;
  while (eventType != XmlPullParser.END_DOCUMENT) {
    switch (eventType) {
      case XmlPullParser.START_TAG:
        String? name = parser.getName();
        if ("Name" == name) {
          result.bucketName = parser.nextText();
        } else if ("Prefix" == name) {
          if (isCommonPrefixes) {
            String? commonPrefix = parser.nextText();
            if (commonPrefix.notNullOrEmpty) {
              result.addCommonPrefix(commonPrefix!);
            }
          } else {
            result.prefix = parser.nextText();
          }
        } else if ("Marker" == name) {
          result.marker = parser.nextText();
        } else if ("Delimiter" == name) {
          result.delimiter = parser.nextText();
        } else if ("EncodingType" == name) {
          result.encodingType = parser.nextText();
        } else if ("MaxKeys" == name) {
          String? maxKeys = parser.nextText();
          if (maxKeys.notNullOrEmpty) {
            result.maxKeys = int.parse(maxKeys!);
          }
        } else if ("NextMarker" == name) {
          result.nextMarker = parser.nextText();
        } else if ("IsTruncated" == name) {
          String? isTruncated = parser.nextText();
          if (isTruncated.notNullOrEmpty) {
            result.isTruncated = isTruncated!.toLowerCase() == 'true';
          }
        } else if ("Contents" == name) {
          object = OSSObjectSummary();
        } else if ("Key" == name) {
          object.key = parser.nextText();
        } else if ("LastModified" == name) {
          object.lastModified = DateUtil.parseIso8601Date(parser.nextText());
        } else if ("Size" == name) {
          String? size = parser.nextText();
          if (size.notNullOrEmpty) {
            object.size = int.parse(size!);
          }
        } else if ("ETag" == name) {
          object.eTag = parser.nextText();
        } else if ("Type" == name) {
          object.type = parser.nextText();
        } else if ("StorageClass" == name) {
          object.storageClass = parser.nextText();
        } else if ("Owner" == name) {
          owner = Owner();
        } else if ("ID" == name) {
          owner?.id = parser.nextText();
        } else if ("DisplayName" == name) {
          owner?.displayName = parser.nextText();
        } else if ("CommonPrefixes" == name) {
          isCommonPrefixes = true;
        }
        break;
      case XmlPullParser.END_TAG:
        String? endTagName = parser.getName();
        if ("Owner" == parser.getName()) {
          if (owner != null) {
            object.owner = owner;
          }
        } else if ("Contents" == endTagName) {
          if (object != null) {
            object.bucketName = result.bucketName;
            result.addObjectSummary(object);
          }
        } else if ("CommonPrefixes" == endTagName) {
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

String? trimQuotes(String? s) {
  if (s == null) return null;

  s = s.trim();
  if (s.startsWith("\"")) s = s.substring(1);
  if (s.endsWith("\"")) s = s.substring(0, s.length - 1);

  return s;
}

/// Unmarshall object metadata from response headers.
ObjectMetadata parseObjectMetadata(Map<String, String> headers) {
  try {
    ObjectMetadata objectMetadata = ObjectMetadata();
    headers.forEach((key, value) {
      if (key.contains(OSSHeaders.ossUserMetadataPrefix)) {
        objectMetadata.addUserMetadata(key, value);
      } else if (key.equalsIgnoreCase(HttpHeaders.lastModified) ||
          key.equalsIgnoreCase(HttpHeaders.date)) {
        try {
          objectMetadata.setHeader(key, DateUtil.parseRfc822Date(value));
        } catch (pe) {
          throw OSSIOException(pe);
        }
      } else if (key.equalsIgnoreCase(HttpHeaders.contentLength)) {
        int valueInt = int.parse(value);
        objectMetadata.setHeader(key, valueInt);
      } else if (key.equalsIgnoreCase(HttpHeaders.eTag)) {
        objectMetadata.setHeader(key, trimQuotes(value));
      } else {
        objectMetadata.setHeader(key, value);
      }
    });

    return objectMetadata;
  } catch (e) {
    throw OSSIOException(e);
  }
}

Exception parseResponseErrorXML(ResponseMessage response, bool isHeadRequest) {
  int statusCode = response.statusCode;
  String? requestId = response.response?.headers[OSSHeaders.ossHeaderRequestId];
  String? code;
  String? message;
  String? hostId;
  String? partNumber;
  String? partEtag;
  String? errorMessage;
  if (!isHeadRequest) {
    try {
      errorMessage = response.response!.body;
      OSSLog.logDebug("errorMessage  ： " + " \n $errorMessage");
      InputStream? inputStream =
          ByteArrayInputStream(utf8.encode(errorMessage));
      XmlPullParser parser = Xml.newPullParser();
      parser.setI[inputStream] = "utf-8";
      int eventType = parser.getEventType();
      while (eventType != XmlPullParser.END_DOCUMENT) {
        switch (eventType) {
          case XmlPullParser.START_TAG:
            if ("Code" == parser.getName()) {
              code = parser.nextText();
            } else if ("Message" == parser.getName()) {
              message = parser.nextText();
            } else if ("RequestId" == parser.getName()) {
              requestId = parser.nextText();
            } else if ("HostId" == parser.getName()) {
              hostId = parser.nextText();
            } else if ("PartNumber" == parser.getName()) {
              partNumber = parser.nextText();
            } else if ("PartEtag" == parser.getName()) {
              partEtag = parser.nextText();
            }
            break;
        }
        eventType = parser.next();
        if (eventType == XmlPullParser.TEXT) {
          eventType = parser.next();
        }
      }
    } on OSSIOException catch (e) {
      return OSSClientException(e);
    } on XmlPullParserException catch (e) {
      return OSSClientException(e);
    }
  }

  OSSServiceException serviceException = OSSServiceException(
      statusCode, message, code, requestId, hostId, errorMessage);
  if (partEtag.notNullOrEmpty) {
    serviceException.partEtag = partEtag;
  }

  if (partNumber.notNullOrEmpty) {
    serviceException.partNumber = partNumber;
  }

  return serviceException;
}

class PutObjectResponseParser extends AbstractResponseParser<PutObjectResult> {
  @override
  PutObjectResult parseData(ResponseMessage response, PutObjectResult result) {
    result.eTag = trimQuotes(response.headers[HttpHeaders.eTag]);
    String? body = response.response?.body;
    if (body.notNullOrEmpty) {
      result.serverCallbackReturnBody = body;
    }
    return result;
  }
}

class AppendObjectResponseParser
    extends AbstractResponseParser<AppendObjectResult> {
  @override
  AppendObjectResult parseData(
      ResponseMessage response, AppendObjectResult result) {
    String? nextPosition = response.headers[OSSHeaders.ossNextAppendPosition];
    if (nextPosition != null) {
      result.nextPosition = (int.parse(nextPosition));
    }
    result.objectCRC64 = (response.headers[OSSHeaders.ossHashCrc64Ecma]);
    return result;
  }
}

class HeadObjectResponseParser
    extends AbstractResponseParser<HeadObjectResult> {
  @override
  HeadObjectResult parseData(
      ResponseMessage response, HeadObjectResult result) {
    result.metadata = (parseObjectMetadata(result.responseHeader));
    return result;
  }
}

class GetObjectResponseParser extends AbstractResponseParser<GetObjectResult> {
  @override
  GetObjectResult parseData(ResponseMessage response, GetObjectResult result) {
    result.metadata = parseObjectMetadata(result.responseHeader);
    result.contentLength = response.contentLength;
    if (response.request?.checkCRC64 ?? false) {
      result.objectContent = (CheckCRC64DownloadInputStream(
          response.content!,
          OSSCRC64(),
          response.contentLength,
          result.serverCRC,
          result.requestId));
    } else {
      result.objectContent = response.content;
    }
    return result;
  }

  @override
  bool needCloseResponse() {
    // keep body stream open for reading content
    return false;
  }
}

class GetObjectACLResponseParser
    extends AbstractResponseParser<GetObjectACLResult> {
  @override
  GetObjectACLResult parseData(
      ResponseMessage response, GetObjectACLResult result) {
    result = parseGetObjectACLResponse(response.content, result);
    return result;
  }
}

class CopyObjectResponseParser
    extends AbstractResponseParser<CopyObjectResult> {
  @override
  CopyObjectResult parseData(
      ResponseMessage response, CopyObjectResult result) {
    result = parseCopyObjectResponseXML(response.content, result);
    return result;
  }
}

class CreateBucketResponseParser
    extends AbstractResponseParser<CreateBucketResult> {
  @override
  CreateBucketResult parseData(
      ResponseMessage response, CreateBucketResult result) {
    if (result.responseHeader.containsKey("Location")) {
      result.bucketLocation = result.responseHeader["Location"];
    }
    return result;
  }
}

class DeleteBucketResponseParser
    extends AbstractResponseParser<DeleteBucketResult> {
  @override
  DeleteBucketResult parseData(
      ResponseMessage response, DeleteBucketResult result) {
    return result;
  }
}

class GetBucketInfoResponseParser
    extends AbstractResponseParser<GetBucketInfoResult> {
  @override
  GetBucketInfoResult parseData(
      ResponseMessage response, GetBucketInfoResult result) {
    result = parseGetBucketInfoResponse(response.content, result);
    return result;
  }
}

class GetBucketACLResponseParser
    extends AbstractResponseParser<GetBucketACLResult> {
  @override
  GetBucketACLResult parseData(
      ResponseMessage response, GetBucketACLResult result) {
    result = parseGetBucketACLResponse(response.content, result);
    return result;
  }
}

class PutBucketRefererResponseParser
    extends AbstractResponseParser<PutBucketRefererResult> {
  @override
  PutBucketRefererResult parseData(
      ResponseMessage response, PutBucketRefererResult result) {
    return result;
  }
}

class GetBucketRefererResponseParser
    extends AbstractResponseParser<GetBucketRefererResult> {
  @override
  GetBucketRefererResult parseData(
      ResponseMessage response, GetBucketRefererResult result) {
    result = parseGetBucketRefererResponse(response.content, result);
    return result;
  }
}

class PutBucketLoggingResponseParser
    extends AbstractResponseParser<PutBucketLoggingResult> {
  @override
  PutBucketLoggingResult parseData(
      ResponseMessage response, PutBucketLoggingResult result) {
    return result;
  }
}

class GetBucketLoggingResponseParser
    extends AbstractResponseParser<GetBucketLoggingResult> {
  @override
  GetBucketLoggingResult parseData(
      ResponseMessage response, GetBucketLoggingResult result) {
    result = parseGetBucketLoggingResponse(response.content, result);
    return result;
  }
}

class DeleteBucketLoggingResponseParser
    extends AbstractResponseParser<DeleteBucketLoggingResult> {
  @override
  DeleteBucketLoggingResult parseData(
      ResponseMessage response, DeleteBucketLoggingResult result) {
    return result;
  }
}

class PutBucketLifecycleResponseParser
    extends AbstractResponseParser<PutBucketLifecycleResult> {
  @override
  PutBucketLifecycleResult parseData(
      ResponseMessage response, PutBucketLifecycleResult result) {
    return result;
  }
}

class GetBucketLifecycleResponseParser
    extends AbstractResponseParser<GetBucketLifecycleResult> {
  @override
  GetBucketLifecycleResult parseData(
      ResponseMessage response, GetBucketLifecycleResult result) {
    result = parseGetBucketLifecycleResponse(response.content, result);
    return result;
  }
}

class DeleteBucketLifecycleResponseParser
    extends AbstractResponseParser<DeleteBucketLifecycleResult> {
  @override
  DeleteBucketLifecycleResult parseData(
      ResponseMessage response, DeleteBucketLifecycleResult result) {
    return result;
  }
}

class DeleteObjectResponseParser
    extends AbstractResponseParser<DeleteObjectResult> {
  @override
  DeleteObjectResult parseData(
      ResponseMessage response, DeleteObjectResult result) {
    return result;
  }
}

class DeleteMultipleObjectResponseParser
    extends AbstractResponseParser<DeleteMultipleObjectResult> {
  @override
  DeleteMultipleObjectResult parseData(
      ResponseMessage response, DeleteMultipleObjectResult result) {
    result = parseDeleteMultipleObjectResponse(response.content, result);
    return result;
  }
}

class ListObjectsResponseParser
    extends AbstractResponseParser<ListObjectsResult> {
  @override
  ListObjectsResult parseData(
      ResponseMessage response, ListObjectsResult result) {
    result = parseObjectListResponse(response.content, result);
    return result;
  }
}

class ListBucketResponseParser
    extends AbstractResponseParser<ListBucketsResult> {
  @override
  ListBucketsResult parseData(
      ResponseMessage response, ListBucketsResult result) {
    result = parseBucketListResponse(response.content, result);
    return result;
  }
}

class InitMultipartResponseParser
    extends AbstractResponseParser<InitiateMultipartUploadResult> {
  @override
  InitiateMultipartUploadResult parseData(
      ResponseMessage response, InitiateMultipartUploadResult result) {
    return parseInitMultipartResponseXML(response.content, result);
  }
}

class UploadPartResponseParser
    extends AbstractResponseParser<UploadPartResult> {
  @override
  UploadPartResult parseData(
      ResponseMessage response, UploadPartResult result) {
    result.eTag = (trimQuotes(response.headers[HttpHeaders.eTag]));
    return result;
  }
}

class AbortMultipartUploadResponseParser
    extends AbstractResponseParser<AbortMultipartUploadResult> {
  @override
  AbortMultipartUploadResult parseData(
      ResponseMessage response, AbortMultipartUploadResult result) {
    return result;
  }
}

class CompleteMultipartUploadResponseParser
    extends AbstractResponseParser<CompleteMultipartUploadResult> {
  @override
  CompleteMultipartUploadResult parseData(
      ResponseMessage response, CompleteMultipartUploadResult result) {
    if (response.headers[HttpHeaders.contentType] == "application/xml") {
      result =
          parseCompleteMultipartUploadResponseXML(response.content, result);
    } else {
      String? body = response.response?.body;
      if (body.notNullOrEmpty) {
        result.serverCallbackReturnBody = body;
      }
    }
    return result;
  }
}

class ListPartsResponseParser extends AbstractResponseParser<ListPartsResult> {
  @override
  ListPartsResult parseData(ResponseMessage response, ListPartsResult result) {
    result = parseListPartsResponseXML(response.content, result);
    return result;
  }
}

class ListMultipartUploadsResponseParser
    extends AbstractResponseParser<ListMultipartUploadsResult> {
  @override
  ListMultipartUploadsResult parseData(
      ResponseMessage response, ListMultipartUploadsResult result) {
    return result.parseData(response);
  }
}

class TriggerCallbackResponseParser
    extends AbstractResponseParser<TriggerCallbackResult> {
  @override
  TriggerCallbackResult parseData(
      ResponseMessage response, TriggerCallbackResult result) {
    String? body = response.response?.body;
    if (body.notNullOrEmpty) {
      result.serverCallbackReturnBody = body;
    }
    return result;
  }
}

class ImagePersistResponseParser
    extends AbstractResponseParser<ImagePersistResult> {
  @override
  ImagePersistResult parseData(
      ResponseMessage response, ImagePersistResult result) {
    return result;
  }
}

class PutSymlinkResponseParser
    extends AbstractResponseParser<PutSymlinkResult> {
  @override
  PutSymlinkResult parseData(
      ResponseMessage response, PutSymlinkResult result) {
    return result;
  }
}

class GetSymlinkResponseParser
    extends AbstractResponseParser<GetSymlinkResult> {
  @override
  GetSymlinkResult parseData(
      ResponseMessage response, GetSymlinkResult result) {
    result.targetObjectName =
        response.headers[OSSHeaders.ossHeaderSymlinkTarget];
    return result;
  }
}

class RestoreObjectResponseParser
    extends AbstractResponseParser<RestoreObjectResult> {
  @override
  RestoreObjectResult parseData(
      ResponseMessage response, RestoreObjectResult result) {
    return result;
  }
}
