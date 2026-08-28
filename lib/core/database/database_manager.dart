import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final FirebaseFirestore _firestore;

  DatabaseManager({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> setData({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collection).doc(documentId).set(data);
  }

  Future<Map<String, dynamic>?> getData({
    required String collection,
    required String documentId,
  }) async {
    final snapshot = await _firestore
        .collection(collection)
        .doc(documentId)
        .get();

    return snapshot.data();
  }

  Future<void> updateData({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection(collection).doc(documentId).update(data);
  }

  Future<void> deleteData({
    required String collection,
    required String documentId,
  }) async {
    await _firestore.collection(collection).doc(documentId).delete();
  }
}
