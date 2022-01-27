import 'dart:convert';

void main() {
  Map<String, String> map = {};
  final mapStr = jsonEncode(map);
  print(mapStr);

  final base64Str = base64.encode(mapStr.codeUnits);
  print(base64Str);
  print(base64.encode(utf8.encode(mapStr)));
}


///eyJoZWxsbyI6IndvcmxkIn0=
