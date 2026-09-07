import '../../../movies/domain/entities/movie.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';
import '../datasources/home_remote_data_source_impl.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource dataSource;

  HomeRepositoryImpl({
    HomeRemoteDataSource? dataSource,
  }) : dataSource = dataSource ?? HomeRemoteDataSourceImpl();

  @override
  Future<List<Movie>> getHomeMovies() {
    return dataSource.getHomeMovies();
  }

  @override
  Future<List<Movie>> getMoviesByGenre(int genreId) {
    return dataSource.getMoviesByGenre(genreId);
  }
}