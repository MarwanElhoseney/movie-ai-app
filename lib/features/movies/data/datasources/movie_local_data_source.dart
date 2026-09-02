import '../models/movie_model.dart';

abstract class MovieLocalDataSource {
  Future<List<MovieModel>> getMovies();
}
