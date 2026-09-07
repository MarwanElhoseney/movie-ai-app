import '../../../movies/data/models/movie_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<MovieModel>> getHomeMovies();

  Future<List<MovieModel>> getMoviesByGenre(int genreId);
}
