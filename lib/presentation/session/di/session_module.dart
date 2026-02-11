import 'package:quilt_flow_app/app/di/base/injectable_module.dart';
import 'package:quilt_flow_app/data/network/session/session_api.dart';
import 'package:quilt_flow_app/domain/session/session_repository.dart';
import 'package:quilt_flow_app/domain/session/use_cases/get_session_user_details_usecase.dart';
import 'package:quilt_flow_app/presentation/session/bloc/session_bloc.dart';

class SessionModule extends InjectableModule {
  SessionModule();

  @override
  Future<void> inject() async {
    safeRegisterSingleton<SessionRepository>(() => SessionApi());
    safeRegisterSingleton<GetSessionUserDetailsUsecase>(
      () => GetSessionUserDetailsUsecase(),
    );
  }

  @override
  void injectBloc() {
    safeRegisterSingleton<SessionBloc>(() => SessionBloc());
  }

  @override
  void dispose() {
    safeUnregister<SessionRepository>();
    safeUnregister<GetSessionUserDetailsUsecase>();
    safeUnregister<SessionBloc>();
  }
}
