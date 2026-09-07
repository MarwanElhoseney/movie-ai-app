import '../entities/movie_credit.dart';
import '../repositories/movie_repository.dart';

class GetMovieCredits {
  final MovieRepository repository;

  GetMovieCredits(this.repository);

  Future<List<MovieCredit>> call(String movieId) {
    return repository.getMovieCredits(movieId);
  }
}
