import '../models/movie_model.dart';

abstract class MovieDetailsRemoteDataSource {
  Future<MovieModel> getMovieDetails(String movieId);
}
