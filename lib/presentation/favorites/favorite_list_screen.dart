import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:quilt_flow_app/app/theme/quilt_theme.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_bloc.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_event.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_state.dart';
import 'package:quilt_flow_app/presentation/favorites/collection_options_widget.dart';
import 'package:quilt_flow_app/presentation/favorites/empty_favorite_view.dart';
import 'package:quilt_flow_app/presentation/favorites/favorite_list_item.dart';
import 'package:quilt_flow_app/presentation/favorites/favorite_shimmer_loading_widget.dart';

class FavoriteListScreen extends StatefulWidget {
  const FavoriteListScreen({super.key});

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _onScroll() {
    if (_isBottom && !context.read<FavoritesBloc>().state.hasReachedMax) {
      int pageSize = context.read<FavoritesBloc>().state.pageSize!;
      pageSize = pageSize + 1;
      context.read<FavoritesBloc>().add(
        GetFavoriteList(
          collectionId: context.read<FavoritesBloc>().state.collectionId!,
          pageSize: context.read<FavoritesBloc>().state.pageSize! + 1,
        ),
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    return _scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              context.read<FavoritesBloc>().state.selectedCollectionName ?? "",
              style: QuiltTheme.imageSelectionDialogText.copyWith(
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_horiz, color: Colors.white),
                onPressed: () {
                  FavoriteListOptionsWidget.show(
                    context,
                    context.read<FavoritesBloc>().state.selectedCollectionName!,
                  );
                },
              ),
            ],
          ),
          body: state.isLoading
              ? const ShimmerLoadingList()
              : state.favorites.isEmpty || state.favorites.isEmpty
              ? TweenAnimationBuilder<double>(
                  duration: const Duration(seconds: 2),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: const EmptyFavoritesView(),
                    );
                  },
                )
              : ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: state.favorites.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    return FavoriteListItem(
                      contentItem: state.favorites[index],
                    );
                  },
                ),
        );
      },
      listener: (context, state) {
        if (state.deleteCollectionStatus ==
            DeleteCollectionStatus.deleteCollectionSuccess) {
          context.pop();
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
