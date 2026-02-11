import 'package:quilt_flow_app/app/di/base/injectable_module.dart';
import 'package:quilt_flow_app/data/network/create_profile/create_profile_api.dart';
import 'package:quilt_flow_app/domain/create_profile/create_profile_repository.dart';
import 'package:quilt_flow_app/domain/create_profile/use_cases/create_profile_use_cases.dart';
import 'package:quilt_flow_app/presentation/auth/create_profile/bloc/create_profile_bloc.dart';

class CreateProfileModule extends InjectableModule {
  @override
  Future<void> inject() async {
    safeRegisterSingleton<CreateProfileRepository>(() => CreateProfileApi());
    safeRegisterSingleton<CreateProfileUseCases>(() => CreateProfileUseCases());
  }

  @override
  void injectBloc() {
    safeRegisterSingleton<CreateProfileBloc>(() => CreateProfileBloc());
  }

  @override
  void dispose() {
    safeUnregister<CreateProfileBloc>();
    safeUnregister<CreateProfileUseCases>();
    safeUnregister<CreateProfileRepository>();
  }
}
