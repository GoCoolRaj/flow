import 'package:quilt_flow_app/app/di/base/injectable_module.dart';
import 'package:quilt_flow_app/presentation/media_player/bloc/media_player_bloc.dart';

class MediaPlayerModule extends InjectableModule {
  @override
  Future<void> inject() async {}

  @override
  void injectBloc() {
    safeRegisterSingleton<MediaPlayerBloc>(() => MediaPlayerBloc());
  }

  @override
  void dispose() {
    safeUnregister<MediaPlayerBloc>();
  }
}
