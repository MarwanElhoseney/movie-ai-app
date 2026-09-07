import '../../../movies/domain/entities/movie.dart';
import '../../domain/entities/actor.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/actor_movies_remote_data_source.dart';
import '../datasources/actor_movies_remote_data_source_impl.dart';
import '../datasources/search_remote_data_source.dart';
import '../datasources/search_remote_data_source_impl.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource dataSource;
  final ActorMoviesRemoteDataSource actorMoviesDataSource;

  SearchRepositoryImpl({
    SearchRemoteDataSource? dataSource,
    ActorMoviesRemoteDataSource? actorMoviesDataSource,
  }) : dataSource = dataSource ?? SearchRemoteDataSourceImpl(),
       actorMoviesDataSource =
           actorMoviesDataSource ?? ActorMoviesRemoteDataSourceImpl();

  @override
  Future<List<Movie>> searchMovies(String query) {
    return dataSource.searchMovies(query);
  }

  @override
  Future<List<Actor>> searchActors(String query) {
    return dataSource.searchActors(query);
  }

  @override
  Future<List<Movie>> getActorMovies(String actorId) {
    return actorMoviesDataSource.getActorMovies(actorId);
  }
}