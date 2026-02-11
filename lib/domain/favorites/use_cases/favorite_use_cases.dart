import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/domain/base/base_use_case.dart';
import 'package:quilt_flow_app/domain/create_profile/model/create_profile_response.dart';
import 'package:quilt_flow_app/domain/favorites/favorites_repository.dart';

class FavoriteUseCases
    implements BaseUseCase<FavoriteRequest, CreateProfileResponse> {
  final _favoriteRepository = GetIt.I<FavoritesRepository>();

  @override
  Future<CreateProfileResponse> execute({FavoriteRequest? request}) {
    return _favoriteRepository.favoriteApi(request!);
  }
}

class FavoriteRequest {
  final String userId;
  final String collectionId;
  final String contentId;
  final bool isFavourite;

  FavoriteRequest({
    required this.userId,
    required this.collectionId,
    required this.contentId,
    required this.isFavourite,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'collectionId': collectionId,
      'contentId': contentId,
      'isFavourite': isFavourite,
    };
  }

  String toJson() => json.encode(toMap());
}
