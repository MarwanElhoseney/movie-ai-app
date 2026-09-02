import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovies {
  final MovieRepository repository;

  const GetMovies(this.repository);

  Future<List<Movie>> call() {
    return repository.getMovies();
  }
}
