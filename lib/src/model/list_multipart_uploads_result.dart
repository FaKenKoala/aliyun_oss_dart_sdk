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

  void setCommonPrefixes(List<String>? commonPrefixes) {
    _commonPrefixes
      ..clear()
      ..addAll(commonPrefixes ?? []);
  }

  void addCommonPrefix(String commonPrefix) {
    _commonPrefixes.add(commonPrefix);
  }

  ListMultipartUploadsResult parseData(ResponseMessage responseMessage) {
    List<MultipartUpload> uploadList = [];
    MultipartUpload? upload;
    bool isCommonPrefixes = false;
    XmlPullParser parser = Xml.newPullParser();
    parser.setInput(responseMessage.content, "utf-8");
    int eventType = parser.getEventType();
    while (eventType != XmlPullParser.END_DOCUMENT) {
      switch (eventType) {
        case XmlPullParser.START_TAG:
          String name = parser.getName();
          if ("Bucket" == name) {
            bucketName = parser.nextText();
          } else if ("Delimiter" == name) {
            delimiter = parser.nextText();
          } else if ("Prefix" == name) {
            if (isCommonPrefixes) {
              String commonPrefix = parser.nextText();
              if (commonPrefix.notNullOrEmpty) {
                addCommonPrefix(commonPrefix);
              }
            } else {
              prefix = parser.nextText();
            }
          } else if ("MaxUploads" == name) {
            String? maxUploadStr = parser.nextText();
            if (maxUploadStr.notNullOrEmpty) {
              maxUploads = int.parse(maxUploadStr!);
            }
          } else if ("IsTruncated" == name) {
            String? truncated = parser.nextText();
            if (truncated.notNullOrEmpty) {
              isTruncated = truncated!.equalsIgnoreCase('true');
            }
          } else if ("KeyMarker" == name) {
            keyMarker = parser.nextText();
          } else if ("UploadIdMarker" == name) {
            uploadIdMarker = parser.nextText();
          } else if ("NextKeyMarker" == name) {
            nextKeyMarker = parser.nextText();
          } else if ("NextUploadIdMarker" == name) {
            nextUploadIdMarker = parser.nextText();
          } else if ("Upload" == name) {
            upload = MultipartUpload();
          } else if ("Key" == name) {
            upload?.key = parser.nextText();
          } else if ("UploadId" == name) {
            upload?.uploadId = parser.nextText();
          } else if ("Initiated" == name) {
            upload?.initiated = DateUtil.parseIso8601Date(parser.nextText());
          } else if ("StorageClass" == name) {
            upload?.storageClass = parser.nextText();
          } else if ("CommonPrefixes" == name) {
            isCommonPrefixes = true;
          }
          break;
        case XmlPullParser.END_TAG:
          if ("Upload" == parser.getName()) {
            uploadList.add(upload);
          } else if ("CommonPrefixes" == parser.getName()) {
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
