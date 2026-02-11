import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/data/local/hive_manager.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/presentation/favorites/favorite_tab_widget.dart';
import 'package:quilt_flow_app/presentation/main_router.dart';
import 'package:quilt_flow_app/presentation/session/bloc/session_bloc.dart';
import 'package:quilt_flow_app/presentation/session/bloc/session_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final String _cachedUserName;
  late final String _cachedDisplayName;

  @override
  void initState() {
    super.initState();
    final hiveManager = GetIt.I<HiveManager>();
    _cachedUserName =
        hiveManager.getFromHive<String>(HiveManager.userName) ?? '';
    _cachedDisplayName =
        hiveManager.getFromHive<String>(HiveManager.firstName) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      bloc: GetIt.I<SessionBloc>(),
      builder: (context, state) {
        final user = state.userDetailsData;
        final userName = user?.userName ?? _cachedUserName;
        final displayName = user?.firstName ?? _cachedDisplayName;
        final profilePicture = user?.profilePicture ?? '';

        ImageProvider? imageProvider;
        if (profilePicture.isNotEmpty) {
          imageProvider = profilePicture.startsWith('http')
              ? NetworkImage(profilePicture)
              : FileImage(File(profilePicture));
        }

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: Text(
                userName.isNotEmpty ? '@$userName' : '',
                style: QuiltTheme.simpleWhiteTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    context.push(MainRouter.settingsScreenPath);
                  },
                  icon: Assets.icons.horizontalThreeDot.svg(
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: const Color(0xFF1F1F21),
                        backgroundImage: imageProvider,
                        child: imageProvider == null
                            ? Text(
                                displayName.isNotEmpty
                                    ? displayName.substring(0, 1).toUpperCase()
                                    : '?',
                                style: QuiltTheme.simpleWhiteTextStyle.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            displayName.isNotEmpty ? displayName : 'Your name',
                            style: QuiltTheme.simpleWhiteTextStyle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TabBar(
                  tabAlignment: TabAlignment.center,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
                  dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  tabs: [
                    Tab(
                      icon: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 6,
                        ),
                        child: Assets.icons.squaresFour.svg(),
                      ),
                    ),
                    Tab(
                      icon: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 6,
                        ),
                        child: Assets.icons.favourites.svg(),
                      ),
                    ),
                  ],
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      Center(
                        child: Text(
                          'Timeline',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      FavoritesTabWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
