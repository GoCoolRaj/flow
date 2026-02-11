import 'package:quilt_flow_app/app/di/base/injectable_module.dart';
import 'package:quilt_flow_app/data/local/hive_manager.dart';
import 'package:quilt_flow_app/data/local/session.dart';
import 'package:quilt_flow_app/data/local/shared_preferences_repository.dart';
import 'package:quilt_flow_app/presentation/components/cache_manager/profile_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataModule extends InjectableModule {
  @override
  Future<void> inject() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    safeRegisterSingleton<SharedPreferences>(() => sharedPreferences);

    safeRegisterSingleton<SharedPreferencesRepository>(
      () => SharedPreferencesRepository(),
    );
    safeRegisterSingleton<Session>(() => Session());
    safeRegisterSingleton<ProfileCacheManager>(() => ProfileCacheManager());

    HiveManager hiveManager = HiveManager();
    await hiveManager.initHive();

    safeRegisterSingleton<HiveManager>(() => hiveManager);
  }

  @override
  void dispose() {
    safeUnregister<Session>();
    safeUnregister<SharedPreferencesRepository>();
    safeUnregister<SharedPreferences>();
    safeUnregister<HiveManager>();
    safeUnregister<ProfileCacheManager>();
  }
}
