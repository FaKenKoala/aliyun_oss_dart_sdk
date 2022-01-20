import 'live_channel_generic_request.dart';
import 'live_channel_status.dart';

class SetLiveChannelRequest extends LiveChannelGenericRequest {
  SetLiveChannelRequest(String bucketName, String liveChannelName, this.status)
      : super(bucketName, liveChannelName);

  LiveChannelStatus status;
}
