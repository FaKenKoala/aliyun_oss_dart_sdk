import 'package:aliyun_oss_dart_sdk/src/common/utils/range_spec.dart';
import 'package:aliyun_oss_dart_sdk/src/event/progress_listener.dart';

import 'get_object_request.dart';
import 'input_serialization.dart';
import 'output_serialization.dart';
import 'select_content_format.dart';

/// This is the request class that is used to select an object from OSS. It
/// wraps all the information needed to select this object.
/// User can pass sql expression to filter csv objects.

enum ExpressionType {
  SQL,
}

class SelectObjectRequest extends GetObjectRequest {
  static final String LINE_RANGE_PREFIX = "line-range=";
  static final String SPLIT_RANGE_PREFIX = "split-range=";

  String expression;
  bool skipPartialDataRecord = false;
  int maxSkippedRecordsAllowed = 0;
  ExpressionType expressionType = ExpressionType.SQL;
  InputSerialization _inputSerialization = InputSerialization();
  OutputSerialization outputSerialization = OutputSerialization();

  ///  scanned bytes progress listener for select request,
  ///  it is different from progressListener from {@link WebServiceRequest} which used for request and response bytes
  ProgressListener? selectProgressListener;

  //lineRange is not a generic requirement, we will move it to somewhere else later.
  List<int> lineRange = [];

  //splitRange is a range of splits, one split is a collection of continuous lines
  List<int> splitRange =[];

  SelectObjectRequest(String bucketName, String key)
      : super(bucketName: bucketName, key: key) {
    process = SUBRESOURCE_CSV_SELECT;
  }

  List<int> getLineRange() {
    return lineRange;
  }

  void setLineRange(int startLine, int endLine) {
    lineRange = [startLine, endLine];
  }

  List<int> getSplitRange() {
    return splitRange;
  }

  void setSplitRange(int startSplit, int endSplit) {
    splitRange = [startSplit, endSplit];
  }

  String lineRangeToString(List<int> range) {
    return rangeToString(LINE_RANGE_PREFIX, range);
  }

  String splitRangeToString(List<int> range) {
    return rangeToString(SPLIT_RANGE_PREFIX, range);
  }

  String rangeToString(String rangePrefix, List<int> range) {
    RangeSpec rangeSpec = RangeSpec.parse(range);
    switch (rangeSpec.type) {
      case Type.NORMAL_RANGE:
        return "$rangePrefix${rangeSpec.start}-${rangeSpec.end}";
      case Type.START_TO:
        return "$rangePrefix${rangeSpec.start}-";
      case Type.TO_END:
        return "$rangePrefix-${rangeSpec.end}";
    }
  }

  InputSerialization getInputSerialization() {
    return _inputSerialization;
  }

  void setInputSerialization(InputSerialization inputSerialization) {
    if (inputSerialization.selectContentFormat ==
        SelectContentFormat.CSV) {
      process = SUBRESOURCE_CSV_SELECT;
    } else {
      process = SUBRESOURCE_JSON_SELECT;
    }
    _inputSerialization = inputSerialization;
  }

}
