import 'generic_result.dart';
import 'live_channel_status.dart';
import 'live_channel_target.dart';

class LiveChannelInfo extends GenericResult {
  String? description;
  LiveChannelStatus? status;
  LiveChannelTarget? target;
}
