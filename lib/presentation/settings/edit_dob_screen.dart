import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quilt_flow_app/app/theme/auth_theme.dart';
import 'package:quilt_flow_app/presentation/components/quilt_button.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_bloc.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_event.dart';
import 'package:quilt_flow_app/presentation/settings/bloc/settings_state.dart';
import 'package:quilt_flow_app/presentation/settings/settings_form_fields.dart';

class EditDobScreen extends StatefulWidget {
  const EditDobScreen({super.key});

  @override
  State<EditDobScreen> createState() => _EditDobScreenState();
}

class _EditDobScreenState extends State<EditDobScreen> {
  DateTime? _selectedDob;

  @override
  void initState() {
    super.initState();
    final user = context.read<SettingsBloc>().state.userDetailsData;
    _selectedDob = user?.dob.isNotEmpty == true
        ? DateTime.tryParse(user!.dob)
        : null;
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
        final dobText = _selectedDob == null
            ? 'Select date of birth'
            : DateFormat('MMM d, yyyy').format(_selectedDob!);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Date of birth'),
            centerTitle: true,
            leading: const BackButton(color: Colors.white),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Date of birth', style: AuthTheme.profileTitle),
                  const SizedBox(height: 8),
                  Text(
                    'We use this to calculate your age.',
                    style: AuthTheme.profileSubtitle,
                  ),
                  const SizedBox(height: 24),
                  SettingsGradientBox(
                    onTap: () async {
                      final now = DateTime.now();
                      final maxDob = DateTime(now.year - 18, now.month, now.day);
                      DateTime initialDate = _selectedDob ?? maxDob;
                      if (initialDate.isAfter(maxDob)) {
                        initialDate = maxDob;
                      }
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: DateTime(1900),
                        lastDate: maxDob,
                        builder: (context, child) {
                          final baseTheme = Theme.of(context);
                          return Theme(
                            data: baseTheme.copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Colors.black,
                                onPrimary: Colors.white,
                                surface: Colors.white,
                                onSurface: Colors.black,
                              ),
                              dialogTheme: const DialogThemeData(
                                backgroundColor: Colors.white,
                              ),
                            ),
                            child: child ?? const SizedBox.shrink(),
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          _selectedDob = picked;
                        });
                      }
                    },
                    child: Text(
                      dobText,
                      style: _selectedDob == null
                          ? AuthTheme.profileHintText
                          : AuthTheme.profileInputText,
                    ),
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
                        SaveDobRequested(_selectedDob),
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
