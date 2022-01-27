import 'package:aliyun_oss_dart_sdk/src/common/lib_common.dart';
import 'package:aliyun_oss_dart_sdk/src/internal/response_message.dart';
import 'multipart_upload.dart';
import 'oss_result.dart';

class ListMultipartUploadsResult extends OSSResult {
  String? bucketName;

  String? keyMarker;

  String? delimiter;

  String? prefix;

  String? uploadIdMarker;

  int maxUploads = 0;

  bool isTruncated = false;

  String? nextKeyMarker;

  String? nextUploadIdMarker;

  final List<MultipartUpload> _multipartUploads = [];

  final List<String> _commonPrefixes = [];

  List<MultipartUpload> getMultipartUploads() {
    return _multipartUploads;
  }

  void setMultipartUploads(List<MultipartUpload>? multipartUploads) {
    _multipartUploads
      ..clear()
      ..addAll(multipartUploads ?? []);
  }

  void addMultipartUpload(MultipartUpload multipartUpload) {
    _multipartUploads.add(multipartUpload);
  }

  List<String> getCommonPrefixes() {
    return _commonPrefixes;
  }

  void setCommonPrefixes(List<String> commonPrefixes) {
    _commonPrefixes
      ..clear()
      ..addAll(commonPrefixes);
  }

  void addCommonPrefix(String commonPrefix) {
    _commonPrefixes.add(commonPrefix);
  }

  ListMultipartUploadsResult parseData(ResponseMessage responseMessage) {
    List<MultipartUpload> uploadList = [];
    MultipartUpload? upload;
    bool isCommonPrefixes = false;
    XmlPullParser parser = Xml.newPullParser();
    parser.setI[responseMessage.getContent()] = "utf-8";
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
            upload = MultipartUpload();
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

    if (uploadList.isNotEmpty) {
      setMultipartUploads(uploadList);
    }

    return this;
  }
}
