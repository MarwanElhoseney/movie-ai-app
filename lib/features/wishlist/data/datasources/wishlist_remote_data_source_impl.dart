import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../movies/data/models/movie_model.dart';
import 'wishlist_remote_data_source.dart';

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final FirebaseFirestore firestore;

  WishlistRemoteDataSourceImpl({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _wishlistCollection(String userId) {
    return firestore.collection('users').doc(userId).collection('wishlist');
  }

  @override
  Future<List<MovieModel>> getWishlist(String userId) async {
    final snapshot = await _wishlistCollection(userId).get();

    return snapshot.docs.map((doc) => MovieModel.fromJson(doc.data())).toList();
  }

  @override
  Future<void> add({required String userId, required MovieModel movie}) async {
    await _wishlistCollection(userId).doc(movie.id).set({
      ...movie.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> remove({required String userId, required String movieId}) async {
    await _wishlistCollection(userId).doc(movieId).delete();
  }

  @override
  Future<bool> isFavorite({
    required String userId,
    required String movieId,
  }) async {
    final document = await _wishlistCollection(userId).doc(movieId).get();

    return document.exists;
  }
}
