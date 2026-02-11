import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:quilt_flow_app/app/theme/auth_theme.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/presentation/auth/create_profile/bloc/create_profile_bloc.dart';
import 'package:quilt_flow_app/presentation/auth/create_profile/bloc/create_profile_event.dart';
import 'package:quilt_flow_app/presentation/auth/create_profile/bloc/create_profile_state.dart';
import 'package:quilt_flow_app/presentation/components/quilt_button.dart';
import 'package:quilt_flow_app/presentation/main_router.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _pageController = PageController();
  final _userNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  int _currentPage = 0;

  static const List<GenderOption> _genderOptions = [
    GenderOption(
      label: 'Female',
      value: 'Female',
      iconAsset: 'assets/icons/gender_female.svg',
    ),
    GenderOption(
      label: 'Male',
      value: 'Male',
      iconAsset: 'assets/icons/gender_male.svg',
    ),
    GenderOption(
      label: 'Non Binary',
      value: 'Non Binary',
      iconAsset: 'assets/icons/gender_non_binary.svg',
    ),
    GenderOption(
      label: 'Other',
      value: 'Other',
      iconAsset: 'assets/icons/gender_other.svg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _userNameController.dispose();
    _firstNameController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    FocusScope.of(context).unfocus();
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _handleBack() {
    if (_currentPage == 0) {
      context.pop();
    } else {
      _goToPage(_currentPage - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateProfileBloc, CreateProfileState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == CreateProfileStatus.success) {
          context.go(MainRouter.profileCompletedScreenPath);
        }
      },
      builder: (context, state) {
        final bool isLastStep = _currentPage == 2;
        final bool canContinue = _currentPage == 0
            ? state.isNameStepValid
            : _currentPage == 1
            ? state.isGenderStepValid
            : state.isDobStepValid;
        final bool isSubmitting =
            state.status == CreateProfileStatus.submitting;

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            leading: GestureDetector(
              onTap: _handleBack,
              child: SizedBox(
                height: 15,
                width: 15,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Assets.icons.appbarBack.svg(fit: BoxFit.contain),
                ),
              ),
            ),
            title: Text(
              'Profile Setup ${_currentPage + 1}/3',
              style: AuthTheme.profileLabel,
            ),
            centerTitle: false,
            shadowColor: Colors.black,
            backgroundColor: Colors.transparent,
            actions: _currentPage == 1
                ? [
                    TextButton(
                      onPressed: () {
                        context.read<CreateProfileBloc>().add(
                          const CreateProfileGenderSkipped(),
                        );
                        _goToPage(_currentPage + 1);
                      },
                      child: const Text(
                        'Skip',
                        style: AuthTheme.profileSkipText,
                      ),
                    ),
                  ]
                : _currentPage == 2
                ? [
                    TextButton(
                      onPressed: () {
                        context.read<CreateProfileBloc>().add(
                          const CreateProfileDobSkipped(),
                        );
                        context.read<CreateProfileBloc>().add(
                          const CreateProfileSubmitted(),
                        );
                      },
                      child: const Text(
                        'Skip',
                        style: AuthTheme.profileSkipText,
                      ),
                    ),
                  ]
                : null,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StepIndicator(currentStep: _currentPage, totalSteps: 3),
                  const SizedBox(height: 24),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (value) {
                        setState(() {
                          _currentPage = value;
                        });
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: NameStep(
                            userNameController: _userNameController,
                            firstNameController: _firstNameController,
                            onUserNameChanged: (value) {
                              context.read<CreateProfileBloc>().add(
                                CreateProfileUserNameChanged(value),
                              );
                            },
                            onFirstNameChanged: (value) {
                              context.read<CreateProfileBloc>().add(
                                CreateProfileFirstNameChanged(value),
                              );
                            },
                          ),
                        ),
                        SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GenderStep(
                            selectedGender: state.gender,
                            options: _genderOptions,
                            onGenderSelected: (gender) {
                              context.read<CreateProfileBloc>().add(
                                CreateProfileGenderChanged(gender),
                              );
                            },
                          ),
                        ),
                        SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: DobStep(
                            dob: state.dob,
                            onDobSelected: (dob) {
                              context.read<CreateProfileBloc>().add(
                                CreateProfileDobChanged(dob),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  QuiltButton(
                    textString: isLastStep ? 'Complete Profile' : 'Next',
                    buttonType: ButtonType.filled,
                    buttonState: isSubmitting
                        ? ButtonState.loading
                        : canContinue
                        ? ButtonState.completed
                        : ButtonState.disabled,
                    expandButton: true,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    onPressed: (_) {
                      if (!canContinue || isSubmitting) return;
                      if (isLastStep) {
                        context.read<CreateProfileBloc>().add(
                          const CreateProfileSubmitted(),
                        );
                      } else {
                        _goToPage(_currentPage + 1);
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final bool isActive = index <= currentStep;
        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 6,
            margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 8),
            decoration: BoxDecoration(
              gradient: isActive ? QuiltTheme.quiltGradient : null,
              color: isActive ? null : const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        );
      }),
    );
  }
}

class NameStep extends StatelessWidget {
  final TextEditingController userNameController;
  final TextEditingController firstNameController;
  final ValueChanged<String> onUserNameChanged;
  final ValueChanged<String> onFirstNameChanged;

  const NameStep({
    super.key,
    required this.userNameController,
    required this.firstNameController,
    required this.onUserNameChanged,
    required this.onFirstNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Create your profile', style: AuthTheme.profileTitle),
        const SizedBox(height: 8),
        Text(
          'Let us know how you want to show up.',
          style: AuthTheme.profileSubtitle,
        ),
        const SizedBox(height: 28),
        const Text('Username', style: AuthTheme.profileLabel),
        const SizedBox(height: 8),
        GradientBorderTextField(
          controller: userNameController,
          hintText: 'Choose a username',
          onChanged: onUserNameChanged,
          onTapOutside: () => FocusScope.of(context).unfocus(),
        ),
        const SizedBox(height: 18),
        const Text('Your name', style: AuthTheme.profileLabel),
        const SizedBox(height: 8),
        GradientBorderTextField(
          controller: firstNameController,
          hintText: 'Add your name',
          onChanged: onFirstNameChanged,
          onTapOutside: () => FocusScope.of(context).unfocus(),
        ),
      ],
    );
  }
}

class GenderStep extends StatelessWidget {
  final String selectedGender;
  final List<GenderOption> options;
  final ValueChanged<String> onGenderSelected;

  const GenderStep({
    super.key,
    required this.selectedGender,
    required this.options,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select your gender', style: AuthTheme.profileTitle),
        const SizedBox(height: 8),
        Text(
          'This helps us personalize your experience.',
          style: AuthTheme.profileSubtitle,
        ),
        const SizedBox(height: 24),
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: options.map((option) {
            final bool isSelected = selectedGender == option.value;
            return GestureDetector(
              onTap: () => onGenderSelected(option.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  gradient: isSelected ? QuiltTheme.quiltGradient : null,
                  color: isSelected ? null : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : const Color(0xFF3D3D3D),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      option.iconAsset,
                      width: 28,
                      height: 28,
                    ),
                    const SizedBox(height: 10),
                    Text(option.label, style: AuthTheme.profileChipText),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class DobStep extends StatelessWidget {
  final DateTime? dob;
  final ValueChanged<DateTime> onDobSelected;

  const DobStep({super.key, required this.dob, required this.onDobSelected});

  @override
  Widget build(BuildContext context) {
    final dobText = dob == null
        ? 'Select date of birth'
        : DateFormat('MMM d, yyyy').format(dob!);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Date of birth', style: AuthTheme.profileTitle),
        const SizedBox(height: 8),
        Text(
          'We use this to calculate your age.',
          style: AuthTheme.profileSubtitle,
        ),
        const SizedBox(height: 24),
        GradientBorderBox(
          onTap: () async {
            final now = DateTime.now();
            final maxDob = DateTime(now.year - 18, now.month, now.day);
            DateTime initialDate = dob ?? maxDob;
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
                    dialogTheme: DialogThemeData(backgroundColor: Colors.white),
                  ),
                  child: child ?? const SizedBox.shrink(),
                );
              },
            );
            if (picked != null) {
              onDobSelected(picked);
            }
          },
          child: Text(
            dobText,
            style: dob == null
                ? AuthTheme.profileHintText
                : AuthTheme.profileInputText,
          ),
        ),
      ],
    );
  }
}

class GradientBorderTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;
  final bool enabled;
  final VoidCallback? onTapOutside;

  const GradientBorderTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.enabled = true,
    this.onTapOutside,
  });

  @override
  State<GradientBorderTextField> createState() =>
      _GradientBorderTextFieldState();
}

class _GradientBorderTextFieldState extends State<GradientBorderTextField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (_isFocused != _focusNode.hasFocus) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AuthTheme.profileFieldOuterDecoration(isFocused: _isFocused),
      padding: const EdgeInsets.all(1.4),
      child: Container(
        decoration: AuthTheme.profileFieldInnerDecoration(),
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          decoration: AuthTheme.profileInputDecoration(widget.hintText),
          style: AuthTheme.profileInputText,
          enabled: widget.enabled,
          onChanged: widget.onChanged,
          onTapOutside: (_) => widget.onTapOutside?.call(),
        ),
      ),
    );
  }
}

class GradientBorderBox extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const GradientBorderBox({
    super.key,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        decoration: AuthTheme.profileFieldOuterDecoration(),
        padding: const EdgeInsets.all(1.4),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: AuthTheme.profileFieldInnerDecoration(),
          child: child,
        ),
      ),
    );
  }
}

class GenderOption {
  final String label;
  final String value;
  final String iconAsset;

  const GenderOption({
    required this.label,
    required this.value,
    required this.iconAsset,
  });
}
