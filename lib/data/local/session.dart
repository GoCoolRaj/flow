import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/data/local/shared_preferences_repository.dart';

class Session {
  final _sharedPreferencesRepository = GetIt.I<SharedPreferencesRepository>();

  Future<void> setLanguage(String language) async {
    await _sharedPreferencesRepository.setString(
      language,
      SharedPreferencesRepository.languageKey,
    );
  }

  String getLanguage() {
    return _sharedPreferencesRepository.getString(
      SharedPreferencesRepository.languageKey,
    );
  }
}
