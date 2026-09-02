import '../../../movies/data/models/movie_model.dart';

abstract class WishlistRemoteDataSource {
  Future<List<MovieModel>> getWishlist(String userId);

  Future<void> add({required String userId, required MovieModel movie});

  Future<void> remove({required String userId, required String movieId});

  Future<bool> isFavorite({required String userId, required String movieId});
}
