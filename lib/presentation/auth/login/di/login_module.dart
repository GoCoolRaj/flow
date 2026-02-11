import 'package:quilt_flow_app/app/di/base/injectable_module.dart';
import 'package:quilt_flow_app/domain/auth/login/use_cases/login_send_email_otp_use_case.dart';
import 'package:quilt_flow_app/domain/auth/login/use_cases/verify_login_otp_use_case.dart';
import 'package:quilt_flow_app/presentation/auth/login/bloc/login_bloc.dart';
import 'package:quilt_flow_app/presentation/auth/otp/bloc/otp_bloc.dart';

class LoginModule extends InjectableModule {
  @override
  void injectBloc() {
    safeRegisterSingleton<OtpBloc>(() => OtpBloc());
    safeRegisterSingleton<LoginBloc>(() => LoginBloc());
  }

  @override
  Future<void> inject() async {
    safeRegisterSingleton<LoginSendEmailOtpUseCase>(
        () => LoginSendEmailOtpUseCase());
    safeRegisterSingleton<VerifyLoginOtpUseCase>(() => VerifyLoginOtpUseCase());
  }

  @override
  void dispose() {
    safeUnregister<LoginBloc>();
    safeUnregister<OtpBloc>();
    safeUnregister<LoginSendEmailOtpUseCase>();
    safeUnregister<VerifyLoginOtpUseCase>();
  }
}
