import 'live_channel.dart';

class LiveChannelListing {
  List<LiveChannel> getLiveChannels() {
    return _liveChannels;
  }

  void addLiveChannel(LiveChannel liveChannel) {
    _liveChannels.add(liveChannel);
  }

  void setObjectSummaries(List<LiveChannel>? liveChannels) {
    _liveChannels.clear();
    _liveChannels.addAll(liveChannels ?? []);
  }

  // The list of LiveChannel instances
  final List<LiveChannel> _liveChannels = [];
  // The prefix filter.
  String? prefix;
  // The marker filter
  String? marker;
  // The max Live Channel count.
  int maxKeys = 0;
  // Flag of if there's remaining Live Channels in OSS server side.
  // True: more object to come; False: no more live channels to return.
  bool isTruncated = false;
  // The next marker filter.
  String? nextMarker;
}
