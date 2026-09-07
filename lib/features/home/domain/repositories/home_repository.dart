import '../../../movies/domain/entities/movie.dart';

abstract class HomeRepository {
  Future<List<Movie>> getHomeMovies();

  Future<List<Movie>> getMoviesByGenre(int genreId);
}