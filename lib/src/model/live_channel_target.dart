/// The persistent storage information for the Live Channel.
class LiveChannelTarget {
  LiveChannelTarget(
      {this.type = liveChannelDefaultType,
      this.fragDuration = liveChannelDefaultFragDuration,
      this.fragCount = liveChannelDefaultFragCount,
      this.playlistName = liveChannelDefaultPlayListName});

  static const String liveChannelDefaultType = "HLS";
  static const int liveChannelDefaultFragDuration = 5;
  static const int liveChannelDefaultFragCount = 3;
  static const String liveChannelDefaultPlayListName = "playlist.m3u8";

  // The video data's format, only HLS is supported now.
  String type;
  // The fragment duration in seconds for each ts file, when type is HLS.
  int fragDuration;
  // The ts file count in the m3u8 file, when type is HLS.
  int fragCount;
  // The m3u8 file's basename, when the type is HLS.
  String playlistName;
}
