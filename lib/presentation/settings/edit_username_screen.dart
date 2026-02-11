import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quilt_flow_app/app/theme/auth_theme.dart';
import 'package:quilt_flow_app/presentation/components/quilt_button.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_event.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_state.dart';
import 'package:quilt_flow_app/presentation/settings/settings_form_fields.dart';

class EditUsernameScreen extends StatefulWidget {
  const EditUsernameScreen({super.key});

  @override
  State<EditUsernameScreen> createState() => _EditUsernameScreenState();
}

class _EditUsernameScreenState extends State<EditUsernameScreen> {
  late final TextEditingController _usernameController;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<SettingsBloc>().state.userDetailsData;
    _usernameController = TextEditingController(text: user?.userName ?? '');
    _hasText = _usernameController.text.trim().isNotEmpty;
    _usernameController.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _usernameController.removeListener(_handleTextChanged);
    _usernameController.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    final hasText = _usernameController.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  String _normalizeUserName(String value) {
    final trimmed = value.trim();
    return trimmed.startsWith('@') ? trimmed.substring(1) : trimmed;
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
        final isSaving = state.status == SettingsStatus.saving;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Username'),
            centerTitle: true,
            leading: const BackButton(color: Colors.white),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Username', style: AuthTheme.profileTitle),
                  const SizedBox(height: 8),
                  Text(
                    'Choose how people find you.',
                    style: AuthTheme.profileSubtitle,
                  ),
                  const SizedBox(height: 24),
                  SettingsGradientTextField(
                    controller: _usernameController,
                    hintText: 'Choose a username',
                    onChanged: (_) {},
                    onTapOutside: () => FocusScope.of(context).unfocus(),
                  ),
                  const Spacer(),
                  QuiltButton(
                    textString: 'Save',
                    buttonState: _hasText
                        ? ButtonState.completed
                        : ButtonState.disabled,
                    expandButton: true,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    onPressed: (_) {
                      if (!_hasText || isSaving) return;
                      context.read<SettingsBloc>().add(
                            SaveUsernameRequested(
                              _normalizeUserName(_usernameController.text),
                            ),
                          );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
