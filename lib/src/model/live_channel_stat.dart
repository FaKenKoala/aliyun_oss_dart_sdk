import 'generic_result.dart';
import 'push_flow_status.dart';

class LiveChannelStat extends GenericResult {
  // The Live Channel's pusing streaming status.
  PushFlowStatus? status;
  // The current pushing streaming's start time of client's connection.
  DateTime? connectedDate;
  // The current pushing streaming's endpoint (including port), when the
  // status is Live.
  String? remoteAddress;
  // The video information.
  VideoStat? videoStat;
  // The audio information.
  AudioStat? audioStat;
}

/// The Live Channel's video and audio information
class VideoStat {
  VideoStat({
    this.width = 0,
    this.height = 0,
    this.frameRate = 0,
    this.bandWidth = 0,
    this.codec = "",
  });

  // The width of the video.
  int width;
  // The height of the video.
  int height;
  // The frame rate of the video.
  int frameRate;
  // The bandwidth of the video.
  int bandWidth;
  // The codec of the video.
  String codec;
}

/// The Live Channel's Audio information
class AudioStat {
  AudioStat({
    this.bandWidth = 0,
    this.sampleRate = 0,
    this.codec = "",
  });

  // The bandwidth of the audio, in bytes/s.
  int bandWidth;
  // The sample rate of the audio, in HZ.
  int sampleRate;
  // The codec of the audio.
  String codec;
}
