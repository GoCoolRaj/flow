import 'package:quilt_flow_app/app/di/base/injectable_module.dart';
import 'package:quilt_flow_app/data/network/auth/auth_api.dart';
import 'package:quilt_flow_app/domain/auth/auth_repository.dart';
import 'package:quilt_flow_app/domain/auth/login/use_cases/login_send_email_otp_use_case.dart';
import 'package:quilt_flow_app/domain/auth/login/use_cases/verify_login_otp_use_case.dart';
import 'package:quilt_flow_app/domain/auth/registration/use_cases/verify_invite_code_use_case.dart';
import 'package:quilt_flow_app/presentation/auth/login/bloc/login_bloc.dart';
import 'package:quilt_flow_app/presentation/auth/otp/bloc/otp_bloc.dart';
import 'package:quilt_flow_app/presentation/auth/registration/bloc/registration_bloc.dart';

class AuthModule extends InjectableModule {
  @override
  Future<void> inject() async {
    safeRegisterSingleton<AuthRepository>(() => AuthApi());
    safeRegisterSingleton<LoginSendEmailOtpUseCase>(
      () => LoginSendEmailOtpUseCase(),
    );
    safeRegisterSingleton<VerifyLoginOtpUseCase>(
      () => VerifyLoginOtpUseCase(),
    );
    safeRegisterSingleton<VerifyInviteCodeUseCase>(
      () => VerifyInviteCodeUseCase(),
    );
  }

  @override
  void injectBloc() {
    safeRegisterSingleton<OtpBloc>(() => OtpBloc());
    safeRegisterSingleton<LoginBloc>(() => LoginBloc());
    safeRegisterSingleton<RegistrationBloc>(() => RegistrationBloc());

    super.injectBloc();
  }

  @override
  void dispose() {
    safeUnregister<OtpBloc>();
    safeUnregister<LoginBloc>();
    safeUnregister<RegistrationBloc>();
    safeUnregister<LoginSendEmailOtpUseCase>();
    safeUnregister<VerifyLoginOtpUseCase>();
    safeUnregister<VerifyInviteCodeUseCase>();
    safeUnregister<AuthRepository>();
  }
}
