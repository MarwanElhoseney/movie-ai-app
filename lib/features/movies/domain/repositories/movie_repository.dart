import '../entities/movie.dart';
import '../entities/movie_credit.dart';

abstract class MovieRepository {
  Future<List<Movie>> getMovies();

  Future<Movie> getMovieDetails(String movieId);

  Future<List<MovieCredit>> getMovieCredits(String movieId);
}