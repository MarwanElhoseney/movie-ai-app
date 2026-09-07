import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/movie_credit_model.dart';
import 'movie_credits_remote_data_source.dart';

class MovieCreditsRemoteDataSourceImpl implements MovieCreditsRemoteDataSource {
  final ApiClient apiClient;

  MovieCreditsRemoteDataSourceImpl({ApiClient? apiClient})
    : apiClient = apiClient ?? ApiClient();

  @override
  Future<List<MovieCreditModel>> getMovieCredits(String movieId) async {
    final response = await apiClient.get(
      ApiConstants.movieCredits(movieId),
      queryParameters: {'language': 'en-US'},
    );

    final data = response.data as Map<String, dynamic>;

    final cast = data['cast'] as List<dynamic>? ?? [];
    final crew = data['crew'] as List<dynamic>? ?? [];

    final castModels = cast.map(
      (item) => MovieCreditModel.fromTmdbCastJson(item as Map<String, dynamic>),
    );

    final crewModels = crew.map(
      (item) => MovieCreditModel.fromTmdbCrewJson(item as Map<String, dynamic>),
    );

    return [...castModels, ...crewModels];
  }
}
