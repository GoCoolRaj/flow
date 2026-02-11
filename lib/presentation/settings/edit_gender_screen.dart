import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quilt_flow_app/app/theme/auth_theme.dart';
import 'package:quilt_flow_app/presentation/components/quilt_button.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_event.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_state.dart';
import 'package:quilt_flow_app/presentation/settings/settings_form_fields.dart';

class EditGenderScreen extends StatefulWidget {
  const EditGenderScreen({super.key});

  @override
  State<EditGenderScreen> createState() => _EditGenderScreenState();
}

class _EditGenderScreenState extends State<EditGenderScreen> {
  static const List<SettingsGenderOption> _genderOptions = [
    SettingsGenderOption(
      label: 'Female',
      value: 'Female',
      iconAsset: 'assets/icons/gender_female.svg',
    ),
    SettingsGenderOption(
      label: 'Male',
      value: 'Male',
      iconAsset: 'assets/icons/gender_male.svg',
    ),
    SettingsGenderOption(
      label: 'Non Binary',
      value: 'Non Binary',
      iconAsset: 'assets/icons/gender_non_binary.svg',
    ),
    SettingsGenderOption(
      label: 'Other',
      value: 'Other',
      iconAsset: 'assets/icons/gender_other.svg',
    ),
  ];

  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    final user = context.read<SettingsBloc>().state.userDetailsData;
    final currentGender = (user?.gender ?? '').toLowerCase().trim();
    final match = _genderOptions.firstWhere(
      (option) => option.value.toLowerCase() == currentGender,
      orElse: () => _genderOptions.last,
    );
    _selectedGender = match.value;
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
            title: const Text('Gender'),
            centerTitle: true,
            leading: const BackButton(color: Colors.white),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select your gender', style: AuthTheme.profileTitle),
                  const SizedBox(height: 8),
                  Text(
                    'This helps us personalize your experience.',
                    style: AuthTheme.profileSubtitle,
                  ),
                  const SizedBox(height: 24),
                  SettingsGenderGrid(
                    selectedGender: _selectedGender,
                    options: _genderOptions,
                    onGenderSelected: (gender) {
                      setState(() {
                        _selectedGender = gender;
                      });
                    },
                  ),
                  const Spacer(),
                  QuiltButton(
                    textString: 'Save',
                    buttonState: ButtonState.completed,
                    expandButton: true,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    onPressed: (_) {
                      if (isSaving) return;
                      context.read<SettingsBloc>().add(
                            SaveGenderRequested(_selectedGender),
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
