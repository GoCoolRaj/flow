import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:quilt_flow_app/app/di/base/injectable_module.dart';
import 'package:quilt_flow_app/app/helpers/quilt_snack_bar_manager.dart';
import 'package:quilt_flow_app/app/router/router_manager.dart';
import 'package:quilt_flow_app/data/network/core/mqtt_manager.dart';
import 'package:quilt_flow_app/firebase_options.dart';

class AppModule {
  // todo: dispose all singletons

  Future<void> init({List<InjectableModule>? modules}) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    GetIt.I.registerSingleton<RouterManager>(RouterManager());
    GetIt.I.registerSingleton<QuiltSnackBarManager>(QuiltSnackBarManager());

    if (kDebugMode) {
      Logger.level = Level.all;
    } else {
      Logger.level = Level.off;
    }

    FlutterError.onError = (details) {
      Logger().e(
        details.exceptionAsString(),
        error: details.exception,
        stackTrace: details.stack,
      );
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Inject dependencies for provided modules
    await Future.forEach<InjectableModule>(modules ?? [], (module) async {
      await module.inject();
      module.injectBloc();
    });
  }

  Future<void> lateInit({List<InjectableModule>? modules}) async {
    Future.forEach<InjectableModule>(modules ?? [], (module) async {
      module.lateInject();
    });

    final mqttManager = MQTTManager.fromConfiguration(
      MqttConfiguration.quiltBroker,
    );
    GetIt.I.registerSingleton<MQTTManager>(mqttManager);
    //await mqttManager.connect();
  }
}
