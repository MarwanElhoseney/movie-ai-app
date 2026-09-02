import '../../../movies/data/models/movie_model.dart';
import '../../../movies/domain/entities/movie.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_remote_data_source.dart';
import '../datasources/wishlist_remote_data_source_impl.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource dataSource;

  WishlistRepositoryImpl({WishlistRemoteDataSource? dataSource})
    : dataSource = dataSource ?? WishlistRemoteDataSourceImpl();

  @override
  Future<List<Movie>> getWishlist(String userId) async {
    return dataSource.getWishlist(userId);
  }

  @override
  Future<void> add({required String userId, required Movie movie}) {
    return dataSource.add(userId: userId, movie: MovieModel.fromEntity(movie));
  }

  @override
  Future<void> remove({required String userId, required String movieId}) {
    return dataSource.remove(userId: userId, movieId: movieId);
  }

  @override
  Future<bool> isFavorite({required String userId, required String movieId}) {
    return dataSource.isFavorite(userId: userId, movieId: movieId);
  }
}
