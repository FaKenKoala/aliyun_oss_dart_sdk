import 'live_channel_generic_request.dart';

class GenerateVodPlaylistRequest extends LiveChannelGenericRequest {
  GenerateVodPlaylistRequest(
    String bucketName,
    String liveChannelName,
    this.playlistName, [
    this.startTime = 0,
    this.endTime = 0,
  ]) : super(bucketName, liveChannelName);

  String playlistName;
  int startTime;
  int endTime;
}
