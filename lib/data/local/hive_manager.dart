import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quilt_flow_app/data/local/favorites/collection_table.dart';
import 'package:quilt_flow_app/domain/favorites/model/collection_object.dart';

class HiveManager {
  static const String _hiveStorageKey = 'hiveStorageKey';
  static const String _vaultBoxName = 'quiltVaultBox';
  static const String _collectionBoxName = 'collectionBox';

  static const String userSessionTokenKey = 'user_token';

  static const String firstName = 'firstName';
  static const String userName = 'userName';
  static const String userIdKey = 'user_id';
  static const String userProfileUpdated = 'user_profile_updated';
  static const String profileImageCreationUpdated =
      'profileImageCreationUpdated';
  static const String fabricCreationUpdated = 'fabricCreationUpdated';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  HiveAesCipher? _cipher;

  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CollectionTableAdapter());
    final cipher = await _getCipher();

    if (!Hive.isBoxOpen(_vaultBoxName)) {
      await Hive.openBox(
        _vaultBoxName,
        encryptionCipher: cipher,
      );
    }

    if (!Hive.isBoxOpen(_collectionBoxName)) {
      await Hive.openBox<CollectionTable>(
        _collectionBoxName,
        encryptionCipher: cipher,
      );
    }
  }

  Future<HiveAesCipher> _getCipher() async {
    if (_cipher != null) return _cipher!;
    String? encryptionKeyString;
    try {
      encryptionKeyString = await _secureStorage.read(key: _hiveStorageKey);
    } catch (e) {
      await _secureStorage.deleteAll();
    }
    if (encryptionKeyString == null) {
      final key = Hive.generateSecureKey();
      encryptionKeyString = base64UrlEncode(key);
      await _secureStorage.write(
        key: _hiveStorageKey,
        value: encryptionKeyString,
      );
    }
    final encryptionKeyUint8List = base64Url.decode(encryptionKeyString);
    _cipher = HiveAesCipher(encryptionKeyUint8List);
    return _cipher!;
  }

  Future<void> saveToHive<T>(String key, T value) async {
    final encryptedBox = Hive.box(_vaultBoxName);
    await encryptedBox.put(key, value);
  }

  T? getFromHive<T>(String key) {
    final encryptedBox = Hive.box(_vaultBoxName);
    return encryptedBox.get(key) as T?;
  }

  Future<void> storeCollectionDetails(CollectionObject collectionObject) async {
    final encryptedBox = Hive.box<CollectionTable>(_collectionBoxName);
    final collectionTable = CollectionTable.fromCollectionObject(
      collectionObject,
    );
    await encryptedBox.put(collectionTable.collectionId, collectionTable);
  }

  List<CollectionObject> getCollectionsList() {
    try {
      final box = Hive.box<CollectionTable>(_collectionBoxName);
      return box.values.map((table) => table.toCollectionObject()).toList();
    } catch (e) {
      throw HiveError('Failed to get collections: $e');
    }
  }

  Future<void> updateCollection(
    CollectionObject collection,
    bool isUpdateExistingCount,
  ) async {
    try {
      final box = Hive.box<CollectionTable>(_collectionBoxName);
      final existingCollection = box.get(collection.collectionId);
      if (existingCollection != null) {
        final updatedCollection = existingCollection.copyWith(
          collectionName: collection.collectionName,
          collectionCount: isUpdateExistingCount
              ? existingCollection.collectionCount
              : collection.collectionCount,
          isFavorite: isUpdateExistingCount
              ? existingCollection.isFavorite
              : collection.isFavorite,
        );
        await box.put(collection.collectionId, updatedCollection);
      } else {
        throw HiveError('Collection not found');
      }
    } catch (e) {
      throw HiveError('Failed to update collection: $e');
    }
  }

  Future<void> updateCollectionFavorite(
    String collectionId,
    bool isFavorited,
  ) async {
    final box = Hive.box<CollectionTable>(_collectionBoxName);
    final collection = box.get(collectionId);
    if (collection != null) {
      final updatedCollection = CollectionTable(
        collectionId: collection.collectionId,
        collectionName: collection.collectionName,
        collectionCount: collection.collectionCount,
        isFavorite: isFavorited,
      );
      await box.put(collectionId, updatedCollection);
    }
  }

  Future<void> updateCollectionFavoriteCount(
    List<CollectionObject> collectionList,
  ) async {
    final box = Hive.box<CollectionTable>(_collectionBoxName);

    final responseCollections = Map.fromEntries(
      collectionList.map((c) => MapEntry(c.collectionId!, c.collectionCount!)),
    );
    for (var boxCollection in box.values) {
      final updatedCount = responseCollections[boxCollection.collectionId] ?? 0;
      final updatedCollection = CollectionTable(
        collectionId: boxCollection.collectionId,
        collectionName: boxCollection.collectionName,
        collectionCount: updatedCount,
        isFavorite: boxCollection.isFavorite,
      );
      await box.put(boxCollection.collectionId, updatedCollection);
    }
  }

  Future<void> deleteCollection(String collectionId) async {
    try {
      final box = Hive.box<CollectionTable>(_collectionBoxName);
      await box.delete(collectionId);
    } catch (e) {
      throw HiveError('Failed to delete collection: $e');
    }
  }

  Future<void> storeCollections(List<CollectionObject> collections) async {
    try {
      final box = Hive.box<CollectionTable>(_collectionBoxName);
      for (var collection in collections) {
        if (collection.collectionId != null) {
          final collectionTable = CollectionTable.fromCollectionObject(
            collection,
          );
          await box.put(collection.collectionId!, collectionTable);
        }
      }
    } catch (e) {
      throw HiveError('Failed to store collections batch: $e');
    }
  }

  Future<void> storeCollectionsBatch(List<CollectionObject> collections) async {
    try {
      final box = Hive.box<CollectionTable>(_collectionBoxName);
      final entries = <String, CollectionTable>{};
      for (var collection in collections) {
        if (collection.collectionId != null) {
          entries[collection.collectionId!] =
              CollectionTable.fromCollectionObject(collection);
        }
      }
      if (entries.isNotEmpty) {
        await box.putAll(entries);
      }
    } catch (e) {
      throw HiveError('Failed to store collections batch: $e');
    }
  }

  Future<void> closeHive() async {
    if (Hive.isBoxOpen(_vaultBoxName)) {
      await Hive.box(_vaultBoxName).close();
    }
  }

  Future<void> clearHive() async {
    try {
      final cipher = await _getCipher();
      if (!Hive.isBoxOpen(_vaultBoxName)) {
        await Hive.openBox(
          _vaultBoxName,
          encryptionCipher: cipher,
        );
      }
      await Hive.box(_vaultBoxName).clear();
      if (!Hive.isBoxOpen(_collectionBoxName)) {
        await Hive.openBox<CollectionTable>(
          _collectionBoxName,
          encryptionCipher: cipher,
        );
      }
      await Hive.box<CollectionTable>(_collectionBoxName).clear();
    } catch (e) {
      throw HiveError('Failed to clear Hive boxes: $e');
    }
  }
}
