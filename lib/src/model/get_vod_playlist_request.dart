import 'live_channel_generic_request.dart';

class GetVodPlaylistRequest extends LiveChannelGenericRequest {
  GetVodPlaylistRequest(
      String bucketName, String liveChannelName, this.startTime, this.endTime)
      : super(bucketName, liveChannelName);

  int startTime;
  int endTime;
}
