import 'log_utils.dart';

enum Type {
  NORMAL_RANGE, // a-b
  START_TO, // a-
  TO_END // -b
}

class RangeSpec {
  static final String RANGE_PREFIX = "bytes=";

  final int start;
  final int end;
  final Type type;

  RangeSpec([this.start = 0, this.end = 0, this.type = Type.NORMAL_RANGE]);

  static RangeSpec parse(List<int>? range) {
    if (range == null || range.length != 2) {
      LogUtils.getLog().warn(
          "Invalid range value $range, ignore it and just get entire object");
    }

    int start = range![0];
    int end = range[1];

    if (start < 0 && end < 0 || (start > 0 && end > 0 && start > end)) {
      LogUtils.getLog().warn(
          "Invalid range value [$start,$end], ignore it and just get entire object");
    }

    RangeSpec rs;
    if (start < 0) {
      rs = RangeSpec(-1, end, Type.TO_END);
    } else if (end < 0) {
      rs = RangeSpec(start, -1, Type.START_TO);
    } else {
      rs = RangeSpec(start, end, Type.NORMAL_RANGE);
    }

    return rs;
  }

  @override
  String toString() {
    String formatted = "";

    switch (type) {
      case Type.NORMAL_RANGE:
        formatted = "$RANGE_PREFIX$start-$end";
        break;

      case Type.START_TO:
        formatted = "$RANGE_PREFIX$start-";
        break;

      case Type.TO_END:
        formatted = "$RANGE_PREFIX-$end";
        break;
    }

    return formatted;
  }
}
