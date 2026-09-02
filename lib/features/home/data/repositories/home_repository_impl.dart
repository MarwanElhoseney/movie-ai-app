import '../../../movies/domain/entities/movie.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_data_source.dart';
import '../datasources/home_local_data_source_impl.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeLocalDataSource dataSource;

  HomeRepositoryImpl({
    HomeLocalDataSource? dataSource,
  }) : dataSource =
      dataSource ?? HomeLocalDataSourceImpl();

  @override
  Future<List<Movie>> getHomeMovies() {
    return dataSource.getHomeMovies();
  }
}