import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quilt_flow_app/app/theme/auth_theme.dart';
import 'package:quilt_flow_app/presentation/components/quilt_button.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_event.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_state.dart';
import 'package:quilt_flow_app/presentation/settings/settings_form_fields.dart';

class EditNameScreen extends StatefulWidget {
  const EditNameScreen({super.key});

  @override
  State<EditNameScreen> createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  late final TextEditingController _nameController;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<SettingsBloc>().state.userDetailsData;
    _nameController = TextEditingController(text: user?.firstName ?? '');
    _hasText = _nameController.text.trim().isNotEmpty;
    _nameController.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_handleTextChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    final hasText = _nameController.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
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
            title: const Text('Name'),
            centerTitle: true,
            leading: const BackButton(color: Colors.white),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your name', style: AuthTheme.profileTitle),
                  const SizedBox(height: 8),
                  Text(
                    'Use your full name.',
                    style: AuthTheme.profileSubtitle,
                  ),
                  const SizedBox(height: 24),
                  SettingsGradientTextField(
                    controller: _nameController,
                    hintText: 'Add your name',
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
                            SaveNameRequested(_nameController.text.trim()),
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
