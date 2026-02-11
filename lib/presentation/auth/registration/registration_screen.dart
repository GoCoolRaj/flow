import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:quilt_flow_app/app/helpers/extensions/string_extensions.dart';
import 'package:quilt_flow_app/app/router/router_manager.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/presentation/auth/registration/bloc/registration_bloc.dart';
import 'package:quilt_flow_app/presentation/auth/registration/bloc/registration_event.dart';
import 'package:quilt_flow_app/presentation/auth/registration/bloc/registration_state.dart';
import 'package:quilt_flow_app/presentation/components/quilt_button.dart';
import 'package:quilt_flow_app/presentation/dashboard/dashboard_router.dart';
import 'package:quilt_flow_app/presentation/main_router.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _inviteCodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _inviteCodeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationBloc, RegistrationState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case RegistrationStatus.otpSent:
            if (GetIt.I<RouterManager>().currentRoute.notContains(
              MainRouter.otpScreenPath,
            )) {
              context.push(MainRouter.otpScreenPath);
            }
            break;
          case RegistrationStatus.userAuthenticated:
            if (state.isUserProfileUpdated) {
              context.go(DashboardRouter.homeFullPath);
            } else {
              context.go(MainRouter.createProfileScreenPath);
            }
            break;
          default:
        }
      },
      builder: (context, state) {
        if (_inviteCodeController.text != state.inviteCode) {
          _inviteCodeController.value = _inviteCodeController.value.copyWith(
            text: state.inviteCode,
            selection: TextSelection.collapsed(offset: state.inviteCode.length),
          );
        }

        if ((state.emailId?.isNotEmpty ?? false) &&
            _emailController.text != state.emailId) {
          _emailController.value = _emailController.value.copyWith(
            text: state.emailId!,
            selection: TextSelection.collapsed(
              offset: state.emailId?.length ?? 0,
            ),
          );
        }

        final bool inviteCodeVerified = state.isInviteCodeVerified;
        final bool showEmailField = inviteCodeVerified;
        final bool isEmailAutofilled = state.emailId?.isNotEmpty ?? false;

        final bool canSendOtp = showEmailField && state.isValidEmailId;
        final ButtonState continueButtonState = showEmailField
            ? (canSendOtp ? ButtonState.completed : ButtonState.disabled)
            : (state.inviteCode.isNotEmpty
                  ? ButtonState.completed
                  : ButtonState.disabled);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Invite Code',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _inviteCodeController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your Invite code',
                hintStyle: TextStyle(color: QuiltTheme.secondaryLabelColor),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF3D3D3D)),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF3D3D3D)),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
              onTapOutside: (_) {
                FocusScope.of(context).unfocus();
              },
              style: const TextStyle(color: Colors.white, fontSize: 16),
              onChanged: (value) {
                context.read<RegistrationBloc>().add(InviteCodeChanged(value));
              },
            ),
            if (state.status == RegistrationStatus.invalidInviteCode)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Invalid invite code. Please try again.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (showEmailField) ...[
              const SizedBox(height: 20),
              const Text(
                'Email Address',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                enabled: !isEmailAutofilled,
                readOnly: isEmailAutofilled,
                enableInteractiveSelection: !isEmailAutofilled,
                decoration: InputDecoration(
                  hintText: 'name@example.com',
                  hintStyle: const TextStyle(
                    color: QuiltTheme.secondaryLabelColor,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF3D3D3D)),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF3D3D3D)),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF3D3D3D)),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  suffixIcon: isEmailAutofilled
                      ? const Icon(
                          Icons.lock,
                          color: QuiltTheme.secondaryLabelColor,
                          size: 18,
                        )
                      : null,
                ),
                onTapOutside: (_) {
                  FocusScope.of(context).unfocus();
                },
                style: TextStyle(
                  color: isEmailAutofilled
                      ? Colors.white.withValues(alpha: 0.6)
                      : Colors.white,
                  fontSize: 16,
                ),
                onChanged: isEmailAutofilled
                    ? null
                    : (value) {
                        context.read<RegistrationBloc>().add(
                          EmailIdChanged(value),
                        );
                      },
              ),
            ],
            const SizedBox(height: 20),
            QuiltButton(
              buttonState: continueButtonState,
              textString: showEmailField ? 'Send OTP' : 'Verify Invite Code',
              expandButton: true,
              padding: const EdgeInsets.symmetric(vertical: 20),
              enabledTextStyle: QuiltTheme.simpleWhiteTextStyle.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
              disabledTextStyle: QuiltTheme.simpleWhiteTextStyle.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: QuiltTheme.secondaryLabelColor,
              ),
              onPressed: (value) {
                if (showEmailField) {
                  context.read<RegistrationBloc>().add(
                    const LoginWithEmailRequested(resendRequest: false),
                  );
                } else {
                  context.read<RegistrationBloc>().add(
                    const InviteCodeSubmitted(),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
