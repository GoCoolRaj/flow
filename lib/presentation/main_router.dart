import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:quilt_flow_app/app/helpers/extensions/string_extensions.dart';
import 'package:quilt_flow_app/app/router/animations/slide_transition_screen.dart';
import 'package:quilt_flow_app/app/router/router_scope.dart';
import 'package:quilt_flow_app/data/local/hive_manager.dart';
import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';
import 'package:quilt_flow_app/presentation/auth/auth_screen.dart';
import 'package:quilt_flow_app/presentation/auth/create_profile/bloc/create_profile_bloc.dart';
import 'package:quilt_flow_app/presentation/auth/create_profile/create_profile_screen.dart';
import 'package:quilt_flow_app/presentation/auth/create_profile/di/create_profile_module.dart';
import 'package:quilt_flow_app/presentation/auth/create_profile/profile_completed_screen.dart';
import 'package:quilt_flow_app/presentation/auth/di/auth_module.dart';
import 'package:quilt_flow_app/presentation/auth/login/bloc/login_bloc.dart';
import 'package:quilt_flow_app/presentation/auth/login/login_screen.dart';
import 'package:quilt_flow_app/presentation/auth/otp/bloc/otp_bloc.dart';
import 'package:quilt_flow_app/presentation/auth/otp/otp_screen.dart';
import 'package:quilt_flow_app/presentation/auth/registration/bloc/registration_bloc.dart';
import 'package:quilt_flow_app/presentation/dashboard/dashboard_router.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_bloc.dart';
import 'package:quilt_flow_app/presentation/favorites/favorite_list_screen.dart';
import 'package:quilt_flow_app/presentation/media_player/bloc/media_player_bloc.dart';
import 'package:quilt_flow_app/presentation/media_player/di/media_player_module.dart';
import 'package:quilt_flow_app/presentation/media_player/media_player_screen.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:quilt_flow_app/presentation/settings/change_profile_photo_screen.dart';
import 'package:quilt_flow_app/presentation/settings/di/settings_module.dart';
import 'package:quilt_flow_app/presentation/settings/edit_dob_screen.dart';
import 'package:quilt_flow_app/presentation/settings/edit_gender_screen.dart';
import 'package:quilt_flow_app/presentation/settings/edit_name_screen.dart';
import 'package:quilt_flow_app/presentation/settings/edit_username_screen.dart';
import 'package:quilt_flow_app/presentation/settings/settings_screen.dart';

class MainRouter {
  static const String initialRoutePath = '/';
  static const String authScreenPath = '/auth';
  static const String loginScreenPath = '/login';
  static const String otpScreenPath = '/login/otp';
  static const String createProfileScreenPath = '/create-profile';
  static const String profileCompletedScreenPath = '/profile-completed';
  static const String settingsScreenPath = '/settings';
  static const String profilePhotoScreenPath = '/settings/profile-photo';
  static const String settingsNameScreenPath = '/settings/name';
  static const String settingsUsernameScreenPath = '/settings/username';
  static const String settingsGenderScreenPath = '/settings/gender';
  static const String settingsDobScreenPath = '/settings/dob';
  static const String favoriteRoute = '/favorite';
  static const String mediaRoute = '/media';

  static List<RouteBase> routes() {
    const Key favoriteRouteScreenKey = Key('favorite');
    const Key mediaRouteScreenKey = Key('media');

    return [
      GoRoute(
        path: initialRoutePath,
        redirect: (context, state) async {
          final isUserLoggedIn = !GetIt.I<HiveManager>()
              .getFromHive<String>(HiveManager.userSessionTokenKey)
              .isNullOrEmpty;
          bool isUserProfileUpdated =
              GetIt.I<HiveManager>().getFromHive(
                HiveManager.userProfileUpdated,
              ) ??
              false;

          if (!isUserLoggedIn) {
            return authScreenPath;
          }
          if (!isUserProfileUpdated) {
            return createProfileScreenPath;
          }
          return DashboardRouter.homeFullPath;
        },
      ),
      GoRoute(
        path: authScreenPath,
        builder: (context, state) {
          final authModule = AuthModule();
          authModule.injectBloc();

          return RouterScope(
            inject: () {
              authModule.inject();
            },
            dispose: () {
              authModule.dispose();
            },

            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(value: GetIt.I<LoginBloc>()),
                BlocProvider.value(value: GetIt.I<RegistrationBloc>()),
              ],
              child: const AuthScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: loginScreenPath,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: otpScreenPath,
        builder: (context, state) {
          return BlocProvider.value(
            value: GetIt.I<OtpBloc>(),
            child: const OtpScreen(),
          );
        },
      ),
      ...DashboardRouter.routes(),
      GoRoute(
        path: settingsScreenPath,
        builder: (context, state) {
          final settingsModule = SettingsModule();
          settingsModule.injectBloc();

          return RouterScope(
            inject: () {
              settingsModule.inject();
            },
            dispose: () {
              settingsModule.dispose();
            },
            child: BlocProvider.value(
              value: GetIt.I<SettingsBloc>(),
              child: const SettingsScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: profilePhotoScreenPath,
        builder: (context, state) {
          return BlocProvider.value(
            value: GetIt.I<SettingsBloc>(),
            child: const ChangeProfilePhotoScreen(),
          );
        },
      ),
      GoRoute(
        path: settingsNameScreenPath,
        builder: (context, state) {
          return BlocProvider.value(
            value: GetIt.I<SettingsBloc>(),
            child: const EditNameScreen(),
          );
        },
      ),
      GoRoute(
        path: settingsUsernameScreenPath,
        pageBuilder: (context, state) {
          return SlideTransitionScreen<void>(
            child: BlocProvider.value(
              value: GetIt.I<SettingsBloc>(),
              child: const EditUsernameScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: settingsGenderScreenPath,
        builder: (context, state) {
          return BlocProvider.value(
            value: GetIt.I<SettingsBloc>(),
            child: const EditGenderScreen(),
          );
        },
      ),
      GoRoute(
        path: settingsDobScreenPath,
        builder: (context, state) {
          return BlocProvider.value(
            value: GetIt.I<SettingsBloc>(),
            child: const EditDobScreen(),
          );
        },
      ),
      GoRoute(
        path: createProfileScreenPath,
        builder: (context, state) {
          final createProfileModule = CreateProfileModule();
          createProfileModule.injectBloc();

          return RouterScope(
            inject: () {
              createProfileModule.inject();
            },
            dispose: () {
              createProfileModule.dispose();
            },
            child: BlocProvider.value(
              value: GetIt.I<CreateProfileBloc>(),
              child: const CreateProfileScreen(),
            ),
          );
        },
      ),
      GoRoute(
        path: profileCompletedScreenPath,
        builder: (context, state) => const ProfileCompletedScreen(),
      ),
      GoRoute(
        path: favoriteRoute,
        name: favoriteRoute,
        pageBuilder: (context, state) {
          return SlideTransitionScreen<void>(
            child: RouterScope(
              key: favoriteRouteScreenKey,
              inject: () {},
              dispose: () {},
              child: BlocProvider<FavoritesBloc>.value(
                value: GetIt.I<FavoritesBloc>(),
                child: const FavoriteListScreen(),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: mediaRoute,
        name: mediaRoute,
        pageBuilder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          ContentItem contentItem = data["content"];
          final mediaPlayerModule = MediaPlayerModule();
          mediaPlayerModule.injectBloc();
          return SlideTransitionScreen<void>(
            child: RouterScope(
              key: mediaRouteScreenKey,
              inject: () {
                mediaPlayerModule.inject();
              },
              dispose: () {
                mediaPlayerModule.dispose();
              },
              child: BlocProvider<MediaPlayerBloc>.value(
                value: GetIt.I<MediaPlayerBloc>(),
                child: MediaPlayerScreen(
                  content: contentItem,
                  videoPlayerController: data["video"],
                ),
              ),
            ),
          );
        },
      ),
    ];
  }
}
