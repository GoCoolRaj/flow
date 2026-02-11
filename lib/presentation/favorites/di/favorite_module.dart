import 'package:quilt_flow_app/app/di/base/injectable_module.dart';
import 'package:quilt_flow_app/data/network/favorites/favorites_api.dart';
import 'package:quilt_flow_app/domain/favorites/favorites_repository.dart';
import 'package:quilt_flow_app/domain/favorites/use_cases/create_collection_use_cases.dart';
import 'package:quilt_flow_app/domain/favorites/use_cases/delete_collection_use_cases.dart';
import 'package:quilt_flow_app/domain/favorites/use_cases/favorite_use_cases.dart';
import 'package:quilt_flow_app/domain/favorites/use_cases/get_collection_list_use_cases.dart';
import 'package:quilt_flow_app/domain/favorites/use_cases/get_favorites_list_use_cases.dart';
import 'package:quilt_flow_app/presentation/favorites/bloc/favorite_bloc.dart';

class FavoriteModule extends InjectableModule {
  final String userId;

  FavoriteModule({required this.userId});
  @override
  Future<void> inject() async {
    safeRegisterSingleton<FavoritesRepository>(() => FavoritesApi());
    safeRegisterSingleton<GetCollectionListUseCases>(
      () => GetCollectionListUseCases(),
    );
    safeRegisterSingleton<CreateCollectionUseCases>(
      () => CreateCollectionUseCases(),
    );
    safeRegisterSingleton<DeleteCollectionUseCases>(
      () => DeleteCollectionUseCases(),
    );
    safeRegisterSingleton<GetFavoritesListUseCases>(
      () => GetFavoritesListUseCases(),
    );
    safeRegisterSingleton<FavoriteUseCases>(() => FavoriteUseCases());
  }

  @override
  void injectBloc() {
    safeRegisterSingleton<FavoritesBloc>(() => FavoritesBloc(userId: userId));
  }

  @override
  Future<void> disposeBloc() async {
    safeUnregister<FavoritesBloc>();
  }

  @override
  void dispose() {
    safeUnregister<FavoritesRepository>();
    safeUnregister<CreateCollectionUseCases>();
    safeUnregister<GetCollectionListUseCases>();
    safeUnregister<DeleteCollectionUseCases>();
    safeUnregister<GetFavoritesListUseCases>();
    safeUnregister<FavoriteUseCases>();
  }
}
