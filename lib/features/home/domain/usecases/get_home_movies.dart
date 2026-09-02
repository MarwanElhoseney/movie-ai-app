import '../../../movies/domain/entities/movie.dart';
import '../repositories/home_repository.dart';

class GetHomeMovies {
  final HomeRepository repository;

  GetHomeMovies(this.repository);

  Future<List<Movie>> call() {
    return repository.getHomeMovies();
  }
}