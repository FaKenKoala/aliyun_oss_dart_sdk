import 'live_channel_generic_request.dart';
import 'live_channel_status.dart';
import 'live_channel_target.dart';

class CreateLiveChannelRequest extends LiveChannelGenericRequest {
  CreateLiveChannelRequest(
    String bucketName,
    String liveChannelName, [
    this.liveChannelDescription = '',
    this.status = LiveChannelStatus.enabled,
    LiveChannelTarget? target,
  ])  : target = target ?? LiveChannelTarget(),
        super(bucketName, liveChannelName);

  String liveChannelDescription;
  LiveChannelStatus status;
  LiveChannelTarget target;
}
