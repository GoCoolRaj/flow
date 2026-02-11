import 'package:quilt_flow_app/app/di/base/injectable_module.dart';
import 'package:quilt_flow_app/presentation/auth/registration/bloc/registration_bloc.dart';

class RegistrationModule extends InjectableModule {
  @override
  void injectBloc() {
    safeRegisterSingleton<RegistrationBloc>(() => RegistrationBloc());
  }

  @override
  Future<void> inject() async {}

  @override
  void dispose() {
    safeUnregister<RegistrationBloc>();
  }
}
