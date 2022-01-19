import 'json_type.dart';

class JsonFormat {
  JsonType? jsonType;

  //Define the delimiter for `output` json records
  String recordDelimiter = "\n";

  bool parseJsonNumberAsString = false;
}
