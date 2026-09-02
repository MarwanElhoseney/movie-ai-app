import '../../../movies/data/datasources/movie_local_data_source.dart';
import '../../../movies/data/datasources/movie_local_data_source_impl.dart';
import '../../../movies/domain/entities/movie.dart';
import 'home_local_data_source.dart';

class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final MovieLocalDataSource movieDataSource;

  HomeLocalDataSourceImpl({
    MovieLocalDataSource? movieDataSource,
  }) : movieDataSource =
      movieDataSource ?? MovieLocalDataSourceImpl();

  @override
  Future<List<Movie>> getHomeMovies() {
    return movieDataSource.getMovies();
  }
}