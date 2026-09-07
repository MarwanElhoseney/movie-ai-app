import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/movie_model.dart';
import 'movie_remote_data_source.dart';

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final ApiClient apiClient;

  MovieRemoteDataSourceImpl({ApiClient? apiClient})
    : apiClient = apiClient ?? ApiClient();

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response = await apiClient.get(
      ApiConstants.popularMovies,
      queryParameters: {'language': 'en-US', 'page': 1},
    );

    final results = response.data['results'] as List<dynamic>? ?? [];

    return results
        .map((json) => MovieModel.fromTmdbJson(json as Map<String, dynamic>))
        .toList();
  }
}
