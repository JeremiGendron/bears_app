import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesInstance {
  static SharedPreferences _sharedPreferences;
  static Future<SharedPreferences> get sharedPreferences async => _sharedPreferences?? () async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return _sharedPreferences;
  }();
}


