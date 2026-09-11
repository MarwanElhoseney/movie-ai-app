import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../movies/data/models/movie_model.dart';
import '../models/actor_model.dart';
import 'search_remote_data_source.dart';

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiClient apiClient;

  SearchRemoteDataSourceImpl({ApiClient? apiClient})
      : apiClient = apiClient ?? ApiClient();

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await apiClient.get(
      ApiConstants.searchMovies,
      queryParameters: {
        'query': query.trim(),
        'page': 1,
        'include_adult': false,
      },
    );

    final results =
        response.data['results'] as List<dynamic>? ?? [];

    return results
        .map(
          (json) =>
          MovieModel.fromTmdbJson(
            json as Map<String, dynamic>,
          ),
    )
        .toList();
  }

  @override
  Future<List<ActorModel>> searchActors(String query) async {
    final response = await apiClient.get(
      ApiConstants.searchActors,
      queryParameters: {
        'query': query.trim(),
        'page': 1,
        'include_adult': false,
      },
    );

    final results =
        response.data['results'] as List<dynamic>? ?? [];

    return results
        .map(
          (json) =>
          ActorModel.fromTmdbJson(
            json as Map<String, dynamic>,
          ),
    )
        .toList();
  }
}