enum Header {
  None, // there is no csv header
  Ignore, // we should ignore csv header and should not use csv header in select sql
  Use // we can use csv header in select sql
}

class CSVFormat {
  //Define the first line of input. Valid values: None, Ignore, Use.
  Header headerInfo = Header.None;

  //Define the delimiter for records
  String recordDelimiter = "\n";

  //Define the comment char, this is a single char, so getter will return the first char
  String? _commentChar = "#";

  //Define the delimiter for fields, this is a single char, so getter will return the first char
  String? _fieldDelimiter = ",";

  //Define the quote char, this is a single char, so getter will return the first char
  String? _quoteChar = "\"";

  bool allowQuotedRecordDelimiter = true;

  String? get commentChar {
    return _commentChar?.isEmpty ?? true ? null : _commentChar!.substring(0, 1);
  }

  void setCommentChar(String commentChar) {
    _commentChar = commentChar;
  }

  String? get fieldDelimiter {
    return _fieldDelimiter?.isEmpty ?? true
        ? null
        : _fieldDelimiter!.substring(0, 1);
  }

  set fieldDelimiter(String? fieldDelimiter) {
    _fieldDelimiter = fieldDelimiter;
  }

  String? get quoteChar {
    return _quoteChar?.isEmpty ?? true ? null : _quoteChar!.substring(0, 1);
  }

  set quoteChar(String? quoteChar) {
    _quoteChar = quoteChar;
  }
}
