import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addData({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    await db.collection(collection).add(data);
  }

  Future<List<Map<String, dynamic>>> loadAll({
    required String collection,
  }) async {
    final snapshot = await db.collection(collection).get();
    return snapshot.docs
        .map(
          (doc) => {
            'id': doc.id, // Firestore document ID
            ...doc.data(), // all your fields
          },
        )
        .toList();
  }

  Future<List<T>> loadAllPickKey<T>({
    required String collection,
    required String key,
  }) async {
    final snapshot = await db.collection(collection).get();
    return snapshot.docs
        .map((doc) => doc.data()[key] as T)
        .whereType<T>() // safely skips docs where the key is missing
        .toList();
  }

  Future<List<Map<String, dynamic>>> loadWhere({
    required String collection,
    required String field,
    required dynamic isEqualTo,
  }) async {
    final snapshot = await db
        .collection(collection)
        .where(field, isEqualTo: isEqualTo)
        .get();
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
  }

  Map<String, dynamic> getOnlyFromMap(List<Map<String, dynamic>> listMap) {
    return listMap[0];
  }

  Future<void> updateWhere({
    required String collection,
    required String field,
    required dynamic isEqualTo,
    required Map<String, dynamic> newData,
  }) async {
    final snapshot = await db
        .collection(collection)
        .where(field, isEqualTo: isEqualTo)
        .get();
    for (final doc in snapshot.docs) {
      await doc.reference.update(newData);
    }
  }

  Future<void> deleteWhere({
    required String collection,
    required String field,
    required dynamic isEqualTo,
  }) async {
    final snapshot = await db
        .collection(collection)
        .where(field, isEqualTo: isEqualTo)
        .get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
