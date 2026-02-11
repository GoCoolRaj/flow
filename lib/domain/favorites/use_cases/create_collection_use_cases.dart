import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:quilt_flow_app/domain/base/base_use_case.dart';
import 'package:quilt_flow_app/domain/favorites/favorites_repository.dart';
import 'package:quilt_flow_app/domain/favorites/model/create_collection_response.dart';

class CreateCollectionUseCases
    implements BaseUseCase<CreateCollectionRequest, CreateCollectionResponse> {
  final _favoriteRepository = GetIt.I<FavoritesRepository>();

  @override
  Future<CreateCollectionResponse> execute({CreateCollectionRequest? request}) {
    return _favoriteRepository.createCollectionApi(request!);
  }
}

class CreateCollectionRequest {
  final String userId;
  final String collectionId;
  final String collectionName;

  CreateCollectionRequest({
    required this.userId,
    required this.collectionId,
    required this.collectionName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'collectionId': collectionId,
      'collectionName': collectionName,
    };
  }

  String toJson() => json.encode(toMap());
}
