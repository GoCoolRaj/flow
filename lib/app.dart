import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:quilt_flow_app/app/router/router_manager.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/data/local/hive_manager.dart';
import 'package:quilt_flow_app/generated/l10n.dart';
import 'package:quilt_flow_app/presentation/components/locale/bloc/locale_bloc.dart';
import 'package:quilt_flow_app/presentation/components/locale/bloc/locale_state.dart';
import 'package:quilt_flow_app/presentation/components/quilt_overlay_indicator.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("app open");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: GetIt.I<LocaleBloc>())],
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          return GlobalLoaderOverlay(
            overlayColor: Colors.grey.withValues(alpha: 0.5),
            overlayWidgetBuilder: (_) {
              return const QuiltOverlayIndicator();
            },

            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              locale: state.locale,
              theme: QuiltTheme.getTheme(),
              supportedLocales: S.delegate.supportedLocales,
              routerConfig: GetIt.I.get<RouterManager>().goRouter,
              builder: (context, child) {
                return child ?? const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Future<void> dispose() async {
    if (kDebugMode) {
      print("app close");
    }
    await GetIt.I<HiveManager>().closeHive();
    super.dispose();
  }
}
