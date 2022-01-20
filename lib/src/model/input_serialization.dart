import 'compression_type.dart';
import 'csv_format.dart';
import 'json_format.dart';
import 'select_content_format.dart';

/// Define input serialization of the select object operations.
class InputSerialization {
  // Default input format is csv
  SelectContentFormat selectContentFormat = SelectContentFormat.CSV;
  CSVFormat csvInputFormat = CSVFormat();
  JsonFormat jsonInputFormat = JsonFormat();
  String compressionType = CompressionType.NONE.name;

  JsonFormat getJsonInputFormat() {
    return jsonInputFormat;
  }

  void setJsonInputFormat(JsonFormat jsonInputFormat) {
    if (jsonInputFormat.jsonType == null) {
      throw ArgumentError(
          "Please set json type for this input, valid types are DOCUMENT and LINES");
    }
    selectContentFormat = SelectContentFormat.JSON;
    this.jsonInputFormat = jsonInputFormat;
  }
}
