import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesRepository {
  final SharedPreferences _sharedPreferences = GetIt.I<SharedPreferences>();

  static const String languageKey = 'languageKey';

  Future<void> setString(String value, String key) async {
    await _sharedPreferences.setString(key, value);
  }

  String getString(String key) {
    return _sharedPreferences.getString(key) ?? '';
  }

  Future<void> setBool(bool value, String key) async {
    await _sharedPreferences.setBool(key, value);
  }

  bool getBool(String key) {
    return _sharedPreferences.getBool(key) ?? false;
  }
}
