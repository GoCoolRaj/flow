import 'package:quilt_flow_app/domain/favorites/model/collection_object.dart';

class CollectionListResponse {
  List<CollectionObject>? collectionList = [];
  CollectionListResponse({required this.collectionList});

  static List<CollectionObject> parseCollectionList(List<dynamic> data) {
    return List<CollectionObject>.from(
      data.map((item) => CollectionObject.fromJson(item["collectionDetails"])),
    );
  }
}
