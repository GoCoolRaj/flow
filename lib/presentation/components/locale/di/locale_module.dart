import 'package:quilt_flow_app/app/di/base/injectable_module.dart';
import 'package:quilt_flow_app/presentation/components/locale/bloc/locale_bloc.dart';

class LocaleModule extends InjectableModule {
  @override
  Future<void> inject() async {
    safeRegisterSingleton<LocaleBloc>(() => LocaleBloc());
  }

  @override
  void dispose() {
    safeUnregister<LocaleBloc>();
  }
}
