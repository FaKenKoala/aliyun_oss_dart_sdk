import 'generic_request.dart';

class LiveChannelGenericRequest extends GenericRequest {
  LiveChannelGenericRequest([
    String? bucketName,
    this.liveChannelName,
  ]) : super(bucketName: bucketName);

  String? liveChannelName;
}
