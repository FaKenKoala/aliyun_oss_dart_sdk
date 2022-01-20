/// This class wraps all the information needed to generate the signed pushing
/// streaming url.
class GenerateRtmpUriRequest {
  String bucketName;
  String liveChannelName;
  String playlistName;
  int expires;
  GenerateRtmpUriRequest(
    this.bucketName,
    this.liveChannelName,
    this.playlistName,
    this.expires,
  );
}
