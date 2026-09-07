import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/movie_model.dart';
import 'movie_certification_remote_data_source.dart';
import 'movie_certification_remote_data_source_impl.dart';
import 'movie_details_remote_data_source.dart';

class MovieDetailsRemoteDataSourceImpl implements MovieDetailsRemoteDataSource {
  final ApiClient apiClient;
  final MovieCertificationRemoteDataSource certificationDataSource;

  MovieDetailsRemoteDataSourceImpl({
    ApiClient? apiClient,
    MovieCertificationRemoteDataSource? certificationDataSource,
  }) : apiClient = apiClient ?? ApiClient(),
       certificationDataSource =
           certificationDataSource ?? MovieCertificationRemoteDataSourceImpl();

  @override
  Future<MovieModel> getMovieDetails(String movieId) async {
    final response = await apiClient.get(
      ApiConstants.movieDetails(movieId),
      queryParameters: {'language': 'en-US'},
    );

    final movie = MovieModel.fromTmdbDetailsJson(
      response.data as Map<String, dynamic>,
    );

    final certification = await certificationDataSource.getMovieCertification(
      movieId,
    );

    return MovieModel(
      id: movie.id,
      title: movie.title,
      posterUrl: movie.posterUrl,
      backdropUrl: movie.backdropUrl,
      year: movie.year,
      duration: movie.duration,
      genre: movie.genre,
      rating: movie.rating,
      certification: certification,
      description: movie.description,
      premium: movie.premium,
    );
  }
}
