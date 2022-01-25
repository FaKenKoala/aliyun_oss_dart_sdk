import 'package:aliyun_oss_dart_sdk/aliyun_oss_dart_sdk.dart';

void main() {
  String test = 'a b*c~d/e+f';
  String result = 'a%20b%2Ac~d/e%2Bf';//'a+b*c%7Ed%2Fe%2Bf';
  String middle = Uri.encodeComponent(test);

  String actual = middle
      .replaceAll("+", "%20")
      .replaceAll("*", "%2A")
      .replaceAll("%7E", "~")
      .replaceAll("%2F", "/");
  print('expect: $result');
  print('middle: $middle');
  print('actual: $actual');
  print(result == actual);
}
