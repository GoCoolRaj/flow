import 'package:quilt_flow_app/app/di/base/injectable_module.dart';
import 'package:quilt_flow_app/data/network/home/home_api.dart';
import 'package:quilt_flow_app/domain/home/home_repository.dart';
import 'package:quilt_flow_app/domain/home/use_cases/for_you_feed_usecase.dart';
import 'package:quilt_flow_app/presentation/home/bloc/for_you_bloc.dart';

class HomeModule extends InjectableModule {
  final String userId;

  HomeModule({required this.userId});

  @override
  Future<void> inject() async {
    safeRegisterSingleton<HomeRepository>(() => HomeApi());
    safeRegisterSingleton<ForYouFeedUseCase>(() => ForYouFeedUseCase());
  }

  @override
  void injectBloc() {
    safeRegisterSingleton<ForYouBloc>(() => ForYouBloc(userId: userId));
  }

  @override
  void dispose() {
    safeUnregister<ForYouFeedUseCase>();
    safeUnregister<HomeRepository>();
  }
}
