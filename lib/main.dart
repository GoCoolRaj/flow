import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:quilt_flow_app/app.dart';
import 'package:quilt_flow_app/app/di/app_module.dart';
import 'package:quilt_flow_app/app/di/data_module.dart';
import 'package:quilt_flow_app/app/di/network_module.dart';
import 'package:quilt_flow_app/presentation/components/locale/di/locale_module.dart';
import 'package:quilt_flow_app/presentation/session/di/session_module.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  await initModules();

  lateInitModules();
}

Future<void> initModules() async {
  final appModule = AppModule();
  await appModule.init(
    modules: [DataModule(), NetworkModule(), SessionModule(), LocaleModule()],
  );

  runApp(const MyApp());
}

Future<void> lateInitModules() async {
  final appModule = AppModule();
  appModule.lateInit(
    modules: [DataModule(), NetworkModule(), SessionModule(), LocaleModule()],
  );
}
