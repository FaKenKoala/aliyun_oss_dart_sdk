import 'csv_format.dart';
import 'json_format.dart';

/// Define how to output results of the select object operations.
class OutputSerialization {
  CSVFormat csvOutputFormat = CSVFormat();
  JsonFormat jsonOutputFormat = JsonFormat();
  // used by csv files
  bool keepAllColumns = false;
  bool payloadCrcEnabled = false;
  bool outputRawData = false;
  bool outputHeader = false;
}
