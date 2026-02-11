class CollectionObject {
  final String? collectionId;
  int? collectionCount;
  final String? collectionName;
  bool? isFavorite;
  CollectionObject(
      {required this.collectionId,
      required this.collectionName,
      this.collectionCount = 0,
      this.isFavorite = false});
  factory CollectionObject.fromJson(Map<String, dynamic> json) {
    return CollectionObject(
      collectionId: json["id"],
      collectionName: json["collectionName"],
      collectionCount: json["count"] ?? 0,
    );
  }
  static List<CollectionObject> parseCollectionList(List<dynamic> data) {
    return List<CollectionObject>.from(data
        .map((item) => CollectionObject.fromJson(item["collectionDetails"])));
  }

  static List<CollectionObject> parseFavoriteCollectionList(
      List<dynamic> data) {
    return List<CollectionObject>.from(
        data.map((item) => CollectionObject.fromJson(item)));
  }

  CollectionObject copyWith({
    String? collectionId,
    String? collectionName,
    int? collectionCount,
    bool? isFavorite,
  }) {
    return CollectionObject(
      collectionId: collectionId ?? this.collectionId,
      collectionName: collectionName ?? this.collectionName,
      collectionCount: collectionCount ?? this.collectionCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
