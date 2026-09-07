import '../../../movies/domain/entities/movie.dart';
import '../repositories/home_repository.dart';

class GetMoviesByGenre {
  final HomeRepository repository;

  GetMoviesByGenre(this.repository);

  Future<List<Movie>> call(int genreId) {
    return repository.getMoviesByGenre(genreId);
  }
}
