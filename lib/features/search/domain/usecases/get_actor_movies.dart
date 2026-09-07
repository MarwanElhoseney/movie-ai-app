import '../../../movies/domain/entities/movie.dart';
import '../repositories/search_repository.dart';

class GetActorMovies {
  final SearchRepository repository;

  GetActorMovies(this.repository);

  Future<List<Movie>> call(String actorId) {
    return repository.getActorMovies(actorId);
  }
}
