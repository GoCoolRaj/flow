import 'package:hive/hive.dart';
import 'package:quilt_flow_app/domain/favorites/model/collection_object.dart';

part 'collection_table.g.dart';

@HiveType(typeId: 1)
class CollectionTable {
  @HiveField(0)
  final String collectionId;

  @HiveField(1)
  final String collectionName;

  @HiveField(2)
  final int collectionCount;

  @HiveField(3)
  final bool isFavorite;

  CollectionTable({
    required this.collectionId,
    required this.collectionName,
    required this.collectionCount,
    this.isFavorite = false,
  });

  factory CollectionTable.fromCollectionObject(CollectionObject obj) {
    return CollectionTable(
      collectionId: obj.collectionId ?? '',
      collectionName: obj.collectionName ?? '',
      collectionCount: obj.collectionCount ?? 0,
      isFavorite: obj.isFavorite ?? false,
    );
  }

  CollectionObject toCollectionObject() {
    return CollectionObject(
      collectionId: collectionId,
      collectionName: collectionName,
      collectionCount: collectionCount,
      isFavorite: isFavorite,
    );
  }

  CollectionTable copyWith({
    String? collectionId,
    String? collectionName,
    int? collectionCount,
    bool? isFavorite,
  }) {
    return CollectionTable(
      collectionId: collectionId ?? this.collectionId,
      collectionName: collectionName ?? this.collectionName,
      collectionCount: collectionCount ?? this.collectionCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
