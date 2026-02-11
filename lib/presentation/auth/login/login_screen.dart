import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/presentation/auth/login/bloc/login_bloc.dart';
import 'package:quilt_flow_app/presentation/auth/login/bloc/login_event.dart';
import 'package:quilt_flow_app/presentation/auth/login/bloc/login_state.dart';
import 'package:quilt_flow_app/presentation/components/quilt_button.dart';
import 'package:quilt_flow_app/presentation/dashboard/dashboard_router.dart';
import 'package:quilt_flow_app/presentation/main_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == LoginStatus.otpSent) {
          context.push(MainRouter.otpScreenPath);
        }
        if (state.status == LoginStatus.userAuthenticated) {
          if (state.isUserProfileUpdated) {
            context.go(DashboardRouter.homeFullPath);
          } else {
            context.go(MainRouter.createProfileScreenPath);
          }
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'name@example.com',
                hintStyle: TextStyle(color: QuiltTheme.labelSecondary),
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
              style: TextStyle(color: Colors.white, fontSize: 16),
              onChanged: (value) {
                context.read<LoginBloc>().add(EmailIdChanged(value));
              },
            ),
            const SizedBox(height: 20),
            QuiltButton(
              buttonState: state.isValidEmailId
                  ? ButtonState.completed
                  : ButtonState.disabled,
              textString: 'Continue',
              expandButton: true,
              padding: const EdgeInsets.symmetric(vertical: 20),
              enabledTextStyle: QuiltTheme.buttonText.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
              disabledTextStyle: QuiltTheme.buttonText.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: QuiltTheme.secondaryLabelColor,
              ),
              onPressed: (value) {
                context.read<LoginBloc>().add(
                  const LoginWithEmailRequested(resendRequest: false),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
