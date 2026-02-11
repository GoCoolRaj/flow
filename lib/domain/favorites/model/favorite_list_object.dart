import 'package:quilt_flow_app/domain/home/model/feeds_response.dart';

class FavoriteListObject {
  final String? collectionId;
  final List<ContentItem> contentList;
  FavoriteListObject({required this.collectionId, required this.contentList});
  factory FavoriteListObject.fromJson(Map<String, dynamic> json) {
    return FavoriteListObject(
      collectionId: json["collectionId"],
      contentList: ContentItem.fromJsonList(json["contents"]),
    );
  }
  static FavoriteListObject parseCollectionList(Map<String, dynamic> data) {
    return FavoriteListObject.fromJson(data);
  }
}
