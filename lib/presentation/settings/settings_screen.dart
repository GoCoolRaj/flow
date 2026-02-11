import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/data/local/hive_manager.dart';
import 'package:quilt_flow_app/domain/session/model/user_details_data.dart';
import 'package:quilt_flow_app/presentation/main_router.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final user = state.userDetailsData;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            centerTitle: true,
            leading: const BackButton(color: Colors.white),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SettingsSectionTitle('PROFILE'),
                const SizedBox(height: 10),
                _SettingsCard(
                  children: [
                    _SettingsRow(
                      title: 'Profile photo',
                      leading: _ProfilePhotoAvatar(user: user),
                      onTap: () {
                        context.push(MainRouter.profilePhotoScreenPath);
                      },
                    ),
                    const _SettingsDivider(),
                    _SettingsRow(
                      title: 'Name',
                      value: _formatFirstName(user),
                      onTap: () {
                        context.push(MainRouter.settingsNameScreenPath);
                      },
                    ),
                    const _SettingsDivider(),
                    _SettingsRow(
                      title: 'Username',
                      value: _formatUsername(user?.userName),
                      onTap: () {
                        context.push(MainRouter.settingsUsernameScreenPath);
                      },
                    ),
                    const _SettingsDivider(),
                    _SettingsRow(
                      title: 'Email',
                      value: user?.email ?? '-',
                      showChevron: false,
                    ),
                    const _SettingsDivider(),
                    _SettingsRow(
                      title: 'Gender',
                      value: _formatValue(user?.gender),
                      onTap: () {
                        context.push(MainRouter.settingsGenderScreenPath);
                      },
                    ),
                    const _SettingsDivider(),
                    _SettingsRow(
                      title: 'Date of birth',
                      value: _formatDob(user?.dob),
                      onTap: () {
                        context.push(MainRouter.settingsDobScreenPath);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const _SettingsSectionTitle('PREFERENCES'),
                const SizedBox(height: 10),
                _SettingsCard(
                  children: const [
                    _SettingsRow(
                      title: 'Notifications',
                      leadingIcon: Icons.notifications,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const _SettingsSectionTitle('ACCOUNT'),
                const SizedBox(height: 12),
                _ActionButton(
                  text: 'Sign Out',
                  onTap: () async {
                    await GetIt.I<HiveManager>().clearHive();
                    if (!context.mounted) return;
                    context.go(MainRouter.authScreenPath);
                  },
                ),
                const SizedBox(height: 12),
                _ActionButton(
                  text: 'Deactivate Account',
                  onTap: () {},
                ),
                const SizedBox(height: 18),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Delete Account',
                      style: QuiltTheme.simpleWhiteTextStyle.copyWith(
                        color: const Color(0xFFD54859),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _formatUsername(String? value) {
    if (value == null || value.trim().isEmpty) return '-';
    return value.startsWith('@') ? value : '@$value';
  }

  static String _formatValue(String? value) {
    if (value == null || value.trim().isEmpty) return '-';
    final lower = value.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }

  static String _formatDob(String? value) {
    if (value == null || value.trim().isEmpty) return '-';
    try {
      final parsed = DateTime.parse(value);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      final month = months[parsed.month - 1];
      final day = parsed.day.toString().padLeft(2, '0');
      return '$month $day, ${parsed.year}';
    } catch (_) {
      return value;
    }
  }

  static String _formatFirstName(UserDetailsData? user) {
    if (user == null) return '-';
    final firstName = user.firstName.trim();
    return firstName.isEmpty ? '-' : firstName;
  }
}

class _SettingsSectionTitle extends StatelessWidget {
  final String text;

  const _SettingsSectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: QuiltTheme.simpleWhiteTextStyle.copyWith(
        color: Colors.white.withValues(alpha: 0.6),
        fontSize: 14,
        letterSpacing: 0.8,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F21),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String title;
  final String? value;
  final Widget? leading;
  final IconData? leadingIcon;
  final VoidCallback? onTap;
  final bool showChevron;

  const _SettingsRow({
    required this.title,
    this.value,
    this.leading,
    this.leadingIcon,
    this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: 12),
            ] else if (leadingIcon != null) ...[
              Icon(leadingIcon, color: Colors.white, size: 22),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: QuiltTheme.simpleWhiteTextStyle.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (value != null) ...[
              const SizedBox(width: 12),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    value!,
                    textAlign: TextAlign.right,
                    style: QuiltTheme.simpleWhiteTextStyle.copyWith(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.65),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
            if (showChevron) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF8A8A8E),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.black.withValues(alpha: 0.4),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _ActionButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2C),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.06),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: QuiltTheme.simpleWhiteTextStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfilePhotoAvatar extends StatelessWidget {
  final UserDetailsData? user;

  const _ProfilePhotoAvatar({required this.user});

  @override
  Widget build(BuildContext context) {
    final imageUrl = user?.profilePicture ?? '';
    final initials = (user?.firstName ?? '').trim();
    final initial =
        initials.isNotEmpty ? initials.substring(0, 1).toUpperCase() : '?';

    if (imageUrl.isNotEmpty) {
      final imageProvider = imageUrl.startsWith('http')
          ? NetworkImage(imageUrl)
          : FileImage(File(imageUrl)) as ImageProvider;
      return CircleAvatar(
        radius: 18,
        backgroundImage: imageProvider,
        backgroundColor: Colors.black,
      );
    }
    return CircleAvatar(
      radius: 18,
      backgroundColor: QuiltTheme.profileInitialBackgroundColor,
      child: Text(
        initial,
        style: QuiltTheme.simpleWhiteTextStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
