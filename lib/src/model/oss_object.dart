import 'package:aliyun_oss_dart_sdk/src/event/progress_input_stream.dart';

import 'generic_result.dart';
import 'object_metadata.dart';

/// The entity class for representing an object in OSS.
/// <p>
/// In OSS, every file is an OSSObject and every single file should be less than
/// 5G for using Simple upload, Form upload and Append Upload. Only multipart
/// upload could upload a single file more than 5G. Any object has key, data and
/// user metadata. The key is the object's name and the data is object's file
/// content. The user metadata is a dictionary of key-value entries to store some
/// custom data about the object.
/// </p>
/// Object naming rules
/// <ul>
/// <li>use UTF-8 encoding</li>
/// <li>Length is between 1 to 1023</li>
/// <li>Could not have slash or backslash</li>
/// </ul>
///
class OSSObject extends GenericResult {
  // Object key (name)
  String? key;

  // Object's bucket name
  String? bucketName;

  // Object's metadata.
  ObjectMetadata metadata = ObjectMetadata();

  // Object's content
  InputStream? objectContent;

  void close() {
    objectContent?.close();
  }

  void forcedClose() {
    response?.abort();
  }

  @override
  String toString() {
    return "OSSObject [key=$key,bucket=${bucketName ?? "<Unknown>"}]";
  }
}
