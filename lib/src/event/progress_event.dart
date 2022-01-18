import 'package:aliyun_oss_dart_sdk/src/event/progress_event_type.dart';

class ProgressEvent {
  ProgressEvent(this.eventType, [this.bytes = 0])
      : assert(bytes >= 0, "bytes transferred must be non-negative");

  final int bytes;
  final ProgressEventType eventType;

  @override
  String toString() {
    return '$eventType, bytes: $bytes';
  }
}
