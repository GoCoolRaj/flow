import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:quilt_flow_app/presentation/main_router.dart';

class RouterManager {
  late final GoRouter goRouter;
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorKey = GlobalKey<NavigatorState>();
  static final homeBranchNavigatorKey = GlobalKey<NavigatorState>();
  static final notificationsBranchNavigatorKey = GlobalKey<NavigatorState>();
  static final searchBranchNavigatorKey = GlobalKey<NavigatorState>();
  static final profileBranchNavigatorKey = GlobalKey<NavigatorState>();

  RouterManager() {
    _initRouter();
  }

  _initRouter() {
    goRouter = GoRouter(
      navigatorKey: rootNavigatorKey,
      debugLogDiagnostics: kDebugMode,
      initialLocation: MainRouter.initialRoutePath,

      routes: MainRouter.routes(),
    );
  }

  String get currentRoute {
    final RouteMatch lastMatch =
        goRouter.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : goRouter.routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();

    return location;
  }
}
