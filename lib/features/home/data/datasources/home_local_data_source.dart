import '../../../movies/domain/entities/movie.dart';

abstract class HomeLocalDataSource {
  Future<List<Movie>> getHomeMovies();
}