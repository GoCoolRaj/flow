import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quilt_flow_app/app/helpers/quilt_utils.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/generated/l10n.dart';
import 'package:quilt_flow_app/presentation/components/quilt_button.dart';
import 'package:quilt_flow_app/presentation/components/quilt_text_field.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_bloc.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_event.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_state.dart';

class CreateCollectionView extends StatelessWidget {
  final VoidCallback onBack;
  final FavoritesState? state;
  const CreateCollectionView({super.key, required this.onBack, this.state});

  @override
  Widget build(BuildContext context) {
    TextEditingController collectionNameController = TextEditingController();
    if (state!.isUpdateView) {
      collectionNameController.text = state!.selectedCollectionName!;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: QuiltTheme.genderInfoTextColor,
                  size: 20,
                ),
                onPressed: onBack,
              ),
              Expanded(
                child: Text(
                  state!.isUpdateView
                      ? S.of(context).s_rename_collection
                      : S.of(context).s_new_collection,
                  style: QuiltTheme.disclaimerHeaderText.copyWith(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: QuiltTheme.genderInfoTextColor,
                  size: 24,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            24,
            16,
            MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    QuiltTextField(
                      textFieldStyle: TextFieldStyle.outlined,
                      autofocus: true,
                      textFieldState: TextFieldState.focused,
                      textFieldType: TextFieldType.name,
                      hint: S.of(context).s_enter_name,
                      controller: collectionNameController,
                      onChanged: (onChanged) {
                        context.read<FavoritesBloc>().add(
                          CollectionNameChanged(onChanged.trim()),
                        );
                      },
                      textStyle: QuiltTheme.profileUserNameText.copyWith(
                        fontSize: 14,
                      ),
                      outlinedFocusedStyle:
                          QuiltTheme.updateProfileFieldEnabled,
                      hintStyle: QuiltTheme.profileAddText.copyWith(
                        color: QuiltTheme.labelTextColor,
                      ),
                      onValidation: (isValid) => {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              QuiltButton(
                buttonType: ButtonType.filled,
                enabledButtonFilledStyle:
                    QuiltTheme.buttonCompletedFilledFabric,
                enabledTextStyle: QuiltTheme.textEnabledTheme.copyWith(
                  color: Colors.white,
                ),
                textString: state!.isUpdateView
                    ? S.of(context).s_save
                    : S.of(context).s_create_collection,
                onPressed: (value) {
                  QuiltUtils.hideKeyboard();
                  if (state!.isUpdateView) {
                    Navigator.of(context).pop();
                    context.read<FavoritesBloc>().add(
                      UpdateCollection(
                        collectionName: state!.collectionName!,
                        collectionId: state!.collectionId!,
                      ),
                    );
                  } else {
                    Navigator.of(context).pop();
                    context.read<FavoritesBloc>().add(
                      CreateCollection(
                        collectionName: state!.collectionName!,
                        isFavorite: state!.isCreateView,
                      ),
                    );
                  }
                },
                buttonState: state!.isCreateCollectionEnabled
                    ? ButtonState.enabled
                    : ButtonState.disabled,
                expandButton: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
