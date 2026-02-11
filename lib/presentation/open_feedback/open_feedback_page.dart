import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quilt_flow_app/app/theme/auth_theme.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/generated/assets.gen.dart';
import 'package:quilt_flow_app/generated/l10n.dart';
import 'package:quilt_flow_app/presentation/components/feedback_text_field.dart';
import 'package:quilt_flow_app/presentation/components/quilt_button.dart';
import 'package:quilt_flow_app/presentation/open_feedback/bloc/open_feedback_bloc.dart';
import 'package:quilt_flow_app/presentation/open_feedback/bloc/open_feedback_event.dart';
import 'package:quilt_flow_app/presentation/open_feedback/bloc/open_feedback_state.dart';

class OpenFeedbackPage extends StatelessWidget {
  const OpenFeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<AssetGenImage> feedbackImages = [
      Assets.images.openFeed1,
      Assets.images.openFeed2,
      Assets.images.openFeed3,
      Assets.images.openFeed4,
      Assets.images.openFeed5,
    ];
    const int maxCharacters = 500;
    final textEditingController = TextEditingController();
    final FocusNode focusNode = FocusNode();
    return BlocConsumer<OpenFeedbackBloc, OpenFeedbackState>(
      builder: (context, state) {
        return Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: QuiltTheme.createProfileSaveTextColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    alignment: Alignment.topRight,
                    margin: const EdgeInsets.only(right: 20, top: 10),
                    child: const Icon(
                      Icons.close_rounded,
                      color: QuiltTheme.genderInfoTextColor,
                      size: 30,
                    ),
                  ),
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 30),
                Text(
                  S.of(context).how_is_your_experience,
                  textAlign: TextAlign.center,
                  style: QuiltTheme.imageSelectionDialogText,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    feedbackImages.length,
                    (index) => InkWell(
                      excludeFromSemantics: true,
                      canRequestFocus: false,
                      enableFeedback: false,
                      splashFactory: NoSplash.splashFactory,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AuthTheme.otpDefaultBackgroundColor,
                              border: Border.all(
                                color: state.selectedPosition == index
                                    ? QuiltTheme.tertiaryColor
                                    : AuthTheme.otpDefaultBackgroundColor,
                                width: 2,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              alignment: Alignment.center,
                              child: feedbackImages[index].image(
                                height: 25,
                                width: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        context.read<OpenFeedbackBloc>().add(
                          PositionChanged(index),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color:
                          AuthTheme.otpDefaultBackgroundColor, // Border color
                      width: 1.0,
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FeedbackTextField(
                        textStyle: QuiltTheme.promptTextStyle,
                        hintText: S.of(context).tell_us_what_you_think,
                        hintStyle: QuiltTheme.openFeedbackText,
                        cursorColor: Colors.white,
                        controller: textEditingController,
                        onTextChanged: (value) {
                          context.read<OpenFeedbackBloc>().add(
                            FeedbackTextChanged(value),
                          );
                        },
                        minLines: 2,
                        maxCharacters: maxCharacters,
                        promptCallback: (value) {},
                        maxLines: 6,
                        maxCollapsed: -1,
                        focusNode: focusNode,
                        allowEmojis: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 20,
                  ),
                  child: QuiltButton(
                    buttonType: ButtonType.filled,
                    enabledButtonFilledStyle: QuiltTheme.dialogCompletedFilled,
                    enabledTextStyle: QuiltTheme.textEnabledTheme.copyWith(
                      color: Colors.white,
                    ),
                    disabledButtonFilledStyle:
                        QuiltTheme.openFeedbackButtonDisabledFilled,
                    textString: S.of(context).send_feedback,
                    onPressed: (value) {
                      context.read<OpenFeedbackBloc>().add(SubmitFeedback());
                    },
                    disabledTextStyle:
                        QuiltTheme.openFeedbackButtonDisabledText,
                    buttonState: state.isSubmitEnabled
                        ? ButtonState.enabled
                        : ButtonState.disabled,
                    expandButton: true,
                  ),
                ),
              ],
            ),
          ],
        );
      },
      listener: (context, state) {
        if (state.status == OpenFeedbackStatus.feedbackSubmitSuccess) {
          Navigator.pop(context, true);
        }
      },
    );
  }
}
