import '../../../movies/domain/entities/movie.dart';

abstract class WishlistRepository {
  Future<List<Movie>> getWishlist(String userId);

  Future<void> add({required String userId, required Movie movie});

  Future<void> remove({required String userId, required String movieId});

  Future<bool> isFavorite({required String userId, required String movieId});
}
