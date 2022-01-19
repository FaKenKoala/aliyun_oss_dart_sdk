import 'live_channel_status.dart';

class LiveChannel {
  LiveChannel([
    this.name,
    this.description,
    this.lastModified,
    this.publishUrls = const [],
    this.playUrls = const [],
  ]);

  @override
  String toString() {
    return "LiveChannel [name=$name,description=$description,status=$status,lastModified=$lastModified,publishUrls=${publishUrls[0]},playUrls=${playUrls[0]}]";
  }

  String? name;
  String? description;
  LiveChannelStatus? status;
  DateTime? lastModified;
  List<String> publishUrls;
  List<String> playUrls;
}
