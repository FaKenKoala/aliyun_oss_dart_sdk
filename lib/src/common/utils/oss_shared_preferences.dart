import 'package:shared_preferences/shared_preferences.dart';

class OSSSharedPreferences {
  static OSSSharedPreferences? _instance;
  SharedPreferences _sp;

  OSSSharedPreferences(this._sp);

  static OSSSharedPreferences instance(SharedPreferences sp) {
    _instance ??= OSSSharedPreferences(sp);
    return _instance!;
  }

  void setStringValue(String key, String value) {
    _sp.setString(key, value);
  }

  String getStringValue(String key) {
    return _sp.getString(key) ?? '';
  }

  void removeKey(String key) {
    _sp.remove(key);
  }

  bool contains(String key) {
    return _sp.containsKey(key);
  }
}
