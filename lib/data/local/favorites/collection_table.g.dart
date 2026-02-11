// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_table.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CollectionTableAdapter extends TypeAdapter<CollectionTable> {
  @override
  final int typeId = 1;

  @override
  CollectionTable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CollectionTable(
      collectionId: fields[0] as String,
      collectionName: fields[1] as String,
      collectionCount: fields[2] as int,
      isFavorite: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CollectionTable obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.collectionId)
      ..writeByte(1)
      ..write(obj.collectionName)
      ..writeByte(2)
      ..write(obj.collectionCount)
      ..writeByte(3)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CollectionTableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
