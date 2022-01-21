import 'package:aliyun_oss_dart_sdk/src/internal/oss_utils.dart';

import 'live_channel_generic_request.dart';

/// This is the request class is used to list Live Channels under a bucket.
class ListLiveChannelsRequest extends LiveChannelGenericRequest {
  static final int MAX_RETURNED_KEYS_LIMIT = 100;

  ListLiveChannelsRequest([
    String? bucketName,
    this.prefix,
    this.marker,
    int? maxKeys,
  ]) : super(bucketName, null) {
    if (maxKeys != null) {
      this.maxKeys = maxKeys;
    }
  }

  int? getMaxKeys() => _maxKeys;

  set maxKeys(int maxKeys) {
    if (maxKeys < 0 || maxKeys > MAX_RETURNED_KEYS_LIMIT) {
      throw ArgumentError(
          OSSUtils.OSS_RESOURCE_MANAGER.getString("MaxKeysOutOfRange"));
    }

    _maxKeys = maxKeys;
  }

  // The prefix filter.
  String? prefix;

  // The marker filter.
  String? marker;

  // The max number of Live Channels to return.
  int? _maxKeys;
}
