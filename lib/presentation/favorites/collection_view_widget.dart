import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/app/helpers/quilt_utils.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_bloc.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_event.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_state.dart';
import 'package:quilt_flow_app/presentation/favorites/collection_list_widget.dart';
import 'package:quilt_flow_app/presentation/favorites/create_collection_view.dart';

class CollectionsViewWidget extends StatelessWidget {
  const CollectionsViewWidget({super.key});
  static void show(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      isDismissible: true,
      enableDrag: true,
      builder: (_) {
        return BlocProvider.value(
          value: GetIt.I<FavoritesBloc>(),
          child: const CollectionsViewWidget(),
        );
      },
    ).then((onValue) {
      GetIt.I<FavoritesBloc>().add(InitFavorite());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: QuiltTheme.otpDefaultBorderColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),
          BlocConsumer<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              if (state.isCreateView ||
                  state.isUpdateView ||
                  state.isNewCollectionCreateView) {
                return CreateCollectionView(
                  onBack: () => {
                    QuiltUtils.hideKeyboard(),
                    if (state.isUpdateView || state.isNewCollectionCreateView)
                      {Navigator.of(context).pop()}
                    else
                      {
                        context.read<FavoritesBloc>().add(
                          ToggleCreateView(false),
                        ),
                      },
                  },
                  state: state,
                );
              } else {
                return CollectionListWidget(
                  onNewCollection: () =>
                      context.read<FavoritesBloc>().add(ToggleCreateView(true)),
                );
              }
            },
            listener: (context, state) {},
          ),
        ],
      ),
    );
  }
}
