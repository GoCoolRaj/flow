import 'package:quilt_flow_app/app/di/base/injectable_module.dart';
import 'package:quilt_flow_app/data/network/create_profile/create_profile_api.dart';
import 'package:quilt_flow_app/domain/create_profile/create_profile_repository.dart';
import 'package:quilt_flow_app/domain/create_profile/use_cases/create_profile_use_cases.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_bloc.dart';

class SettingsModule extends InjectableModule {
  @override
  Future<void> inject() async {
    safeRegisterSingleton<CreateProfileRepository>(() => CreateProfileApi());
    safeRegisterSingleton<CreateProfileUseCases>(() => CreateProfileUseCases());
  }

  @override
  void injectBloc() {
    safeRegisterSingleton<SettingsBloc>(() => SettingsBloc());
  }

  @override
  void dispose() {
    safeUnregister<SettingsBloc>();
    safeUnregister<CreateProfileUseCases>();
    safeUnregister<CreateProfileRepository>();
  }
}
