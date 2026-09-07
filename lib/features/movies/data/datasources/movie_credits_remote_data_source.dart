import '../models/movie_credit_model.dart';

abstract class MovieCreditsRemoteDataSource {
  Future<List<MovieCreditModel>> getMovieCredits(String movieId);
}
