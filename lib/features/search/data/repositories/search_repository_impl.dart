import '../../../movies/domain/entities/movie.dart';
import '../../domain/entities/actor.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_local_data_source.dart';
import '../datasources/search_local_data_source_impl.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchLocalDataSource dataSource;

  SearchRepositoryImpl({SearchLocalDataSource? dataSource})
    : dataSource = dataSource ?? SearchLocalDataSourceImpl();

  @override
  Future<List<Movie>> searchMovies(String query) {
    return dataSource.searchMovies(query);
  }

  @override
  Future<List<Actor>> searchActors(String query) {
    return dataSource.searchActors(query);
  }
}
