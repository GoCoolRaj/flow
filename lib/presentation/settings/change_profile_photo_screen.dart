import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_event.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_state.dart';

class ChangeProfilePhotoScreen extends StatefulWidget {
  const ChangeProfilePhotoScreen({super.key});

  @override
  State<ChangeProfilePhotoScreen> createState() =>
      _ChangeProfilePhotoScreenState();
}

class _ChangeProfilePhotoScreenState extends State<ChangeProfilePhotoScreen> {
  String? _localPath;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    if (picked == null) return;
    setState(() {
      _localPath = picked.path;
    });
    if (!mounted) return;
    context.read<SettingsBloc>().add(SaveProfilePhotoRequested(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == SettingsStatus.saved) {
          context.read<SettingsBloc>().add(const ClearSettingsStatus());
          Navigator.of(context).pop();
        } else if (state.status == SettingsStatus.failure) {
          context.read<SettingsBloc>().add(const ClearSettingsStatus());
        }
      },
      builder: (context, state) {
        final user = state.userDetailsData;
        final imageUrl = _localPath ?? user?.profilePicture ?? '';
        final initials = (user?.firstName ?? '').trim();
        final initial = initials.isNotEmpty
            ? initials.substring(0, 1).toUpperCase()
            : '?';

        ImageProvider? imageProvider;
        if (imageUrl.isNotEmpty) {
          imageProvider = imageUrl.startsWith('http')
              ? NetworkImage(imageUrl)
              : FileImage(File(imageUrl));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile photo'),
            centerTitle: true,
            leading: const BackButton(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 64,
                  backgroundColor: const Color(0xFF1F1F21),
                  backgroundImage: imageProvider,
                  child: imageProvider == null
                      ? Text(
                          initial,
                          style: QuiltTheme.simpleWhiteTextStyle.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 24),
                Text(
                  'Update your profile picture',
                  style: QuiltTheme.simpleWhiteTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const Spacer(),
                _ChangePhotoButton(
                  text: 'Change Photo',
                  onTap: _pickImage,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChangePhotoButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _ChangePhotoButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: QuiltTheme.quiltGradient,
          borderRadius: BorderRadius.circular(30),
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
