import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_credit.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_credits_remote_data_source.dart';
import '../datasources/movie_credits_remote_data_source_impl.dart';
import '../datasources/movie_details_remote_data_source.dart';
import '../datasources/movie_details_remote_data_source_impl.dart';
import '../datasources/movie_remote_data_source.dart';
import '../datasources/movie_remote_data_source_impl.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource movieDataSource;
  final MovieDetailsRemoteDataSource movieDetailsDataSource;
  final MovieCreditsRemoteDataSource movieCreditsDataSource;

  MovieRepositoryImpl({
    MovieRemoteDataSource? movieDataSource,
    MovieDetailsRemoteDataSource? movieDetailsDataSource,
    MovieCreditsRemoteDataSource? movieCreditsDataSource,
  }) : movieDataSource = movieDataSource ?? MovieRemoteDataSourceImpl(),
       movieDetailsDataSource =
           movieDetailsDataSource ?? MovieDetailsRemoteDataSourceImpl(),
       movieCreditsDataSource =
           movieCreditsDataSource ?? MovieCreditsRemoteDataSourceImpl();

  @override
  Future<List<Movie>> getMovies() {
    return movieDataSource.getPopularMovies();
  }

  @override
  Future<Movie> getMovieDetails(String movieId) {
    return movieDetailsDataSource.getMovieDetails(movieId);
  }

  @override
  Future<List<MovieCredit>> getMovieCredits(String movieId) {
    return movieCreditsDataSource.getMovieCredits(movieId);
  }
}