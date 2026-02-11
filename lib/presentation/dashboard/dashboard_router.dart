import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:quilt_flow_app/app/router/router_scope.dart';
import 'package:quilt_flow_app/data/local/hive_manager.dart';
import 'package:quilt_flow_app/presentation/dashboard/notification_screen.dart';
import 'package:quilt_flow_app/presentation/dashboard/profile_screen.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_bloc.dart';
import 'package:quilt_flow_app/presentation/favorites/di/favorite_module.dart';
import 'package:quilt_flow_app/presentation/home/bloc/for_you_bloc.dart';
import 'package:quilt_flow_app/presentation/home/di/home_module.dart';
import 'package:quilt_flow_app/presentation/home/home_screen.dart';
import 'package:quilt_flow_app/presentation/open_feedback/di/open_feedback_module.dart';
import 'package:quilt_flow_app/presentation/session/bloc/session_bloc.dart';
import 'package:quilt_flow_app/presentation/session/bloc/session_state.dart';

class DashboardRouter {
  static const String dashboardPath = '/dashboard';
  static const String homeRoute = 'home';
  static const String notificationsRoute = 'notifications';
  static const String profileRoute = 'profile';

  static String get homeFullPath => '$dashboardPath/$homeRoute';
  static String get notificationsFullPath =>
      '$dashboardPath/$notificationsRoute';
  static String get profileFullPath => '$dashboardPath/$profileRoute';

  static List<RouteBase> routes() {
    return [
      GoRoute(path: dashboardPath, redirect: (_, __) => homeFullPath),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          final currentUserId = GetIt.I<HiveManager>().getFromHive(
            HiveManager.userIdKey,
          );
          final homeModule = HomeModule(userId: currentUserId);
          final sessionBloc = GetIt.I<SessionBloc>();
          final sessionState = sessionBloc.state;
          final sessionUserId = sessionState.userId;
          FavoriteModule? favoriteModule = FavoriteModule(
            userId: sessionUserId,
          );
          final openFeedbackModule = OpenFeedbackModule();
          homeModule.injectBloc();
          openFeedbackModule.injectBloc();
          favoriteModule.injectBloc();

          return RouterScope(
            inject: () {
              homeModule.inject();
              favoriteModule.inject();
              openFeedbackModule.inject();
            },
            dispose: () {
              homeModule.dispose();
              favoriteModule.dispose();
              favoriteModule.disposeBloc();
              openFeedbackModule.dispose();
            },
            child: DashboardShell(navigationShell: navigationShell),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: homeFullPath,
                builder: (context, state) {
                  final userId =
                      GetIt.I<HiveManager>().getFromHive(
                        HiveManager.userIdKey,
                      ) ??
                      '';
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: GetIt.I<ForYouBloc>()),
                      BlocProvider.value(value: GetIt.I<FavoritesBloc>()),
                      BlocProvider.value(value: GetIt.I<SessionBloc>()),
                    ],
                    child: const HomeScreen(),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: notificationsFullPath,
                builder: (context, state) => const NotificationScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: profileFullPath,
                builder: (context, state) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: GetIt.I<FavoritesBloc>()),
                    ],
                    child: const ProfileScreen(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ];
  }
}

class DashboardShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const DashboardShell({super.key, required this.navigationShell});

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                child: BlocBuilder<SessionBloc, SessionState>(
                  bloc: GetIt.I<SessionBloc>(),
                  builder: (context, state) {
                    return _LiquidGlassNavBar(
                      currentIndex: navigationShell.currentIndex,
                      onTap: (index) => _onTap(context, index),
                      profileImage: state.userDetailsData?.profilePicture,
                      profileInitial: state.userDetailsData?.firstName,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LiquidGlassNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final String? profileImage;
  final String? profileInitial;

  const _LiquidGlassNavBar({
    required this.currentIndex,
    required this.onTap,
    this.profileImage,
    this.profileInitial,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 0.6),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _NavItem(
                  icon: Icons.home_filled,
                  isActive: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                const SizedBox(width: 10),
                _NavItem(
                  icon: Icons.notifications,
                  isActive: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
                const SizedBox(width: 10),
                _NavItem(
                  icon: Icons.person,
                  isActive: currentIndex == 2,
                  onTap: () => onTap(2),
                  child: _ProfileAvatar(
                    isActive: currentIndex == 2,
                    profileImage: profileImage,
                    profileInitial: profileInitial,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final Widget? child;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: 62,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: isActive
              ? Colors.white.withValues(alpha: 0.22)
              : Colors.transparent,
        ),
        child:
            child ??
            Icon(
              icon,
              color: isActive
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.7),
              size: 26,
            ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final bool isActive;
  final String? profileImage;
  final String? profileInitial;

  const _ProfileAvatar({
    required this.isActive,
    this.profileImage,
    this.profileInitial,
  });

  @override
  Widget build(BuildContext context) {
    final initial = (profileInitial ?? '').trim();
    final letter = initial.isNotEmpty ? initial.substring(0, 1) : '';
    final image = profileImage ?? '';

    ImageProvider? imageProvider;
    if (image.isNotEmpty) {
      imageProvider = image.startsWith('http')
          ? NetworkImage(image)
          : FileImage(File(image));
    }

    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.black.withValues(alpha: 0.2),
      backgroundImage: imageProvider,
      child: imageProvider == null
          ? (letter.isNotEmpty
              ? Text(
                  letter.toUpperCase(),
                  style: TextStyle(
                    color: isActive
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Icon(
                  Icons.person,
                  size: 16,
                  color:
                      isActive ? Colors.white : Colors.white.withValues(alpha: 0.7),
                ))
          : null,
    );
  }
}
