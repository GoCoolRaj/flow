import 'package:quilt_flow_app/app/di/base/injectable_module.dart';
import 'package:quilt_flow_app/data/network/open_feedback/open_feedback_api.dart';
import 'package:quilt_flow_app/domain/open_feedback/open_feedback_repository.dart';
import 'package:quilt_flow_app/domain/open_feedback/use_cases/save_feedback_use_cases.dart';
import 'package:quilt_flow_app/presentation/open_feedback/bloc/open_feedback_bloc.dart';

class OpenFeedbackModule extends InjectableModule {
  @override
  Future<void> inject() async {
    safeRegisterSingleton<OpenFeedbackRepository>(() => OpenFeedbackApi());
    safeRegisterSingleton<SaveFeedbackUseCases>(() => SaveFeedbackUseCases());
  }

  @override
  void injectBloc() {
    safeRegisterSingleton<OpenFeedbackBloc>(() => OpenFeedbackBloc());
  }

  @override
  void dispose() {
    safeUnregister<SaveFeedbackUseCases>();
    safeUnregister<OpenFeedbackBloc>();
    safeUnregister<OpenFeedbackRepository>();
  }
}
