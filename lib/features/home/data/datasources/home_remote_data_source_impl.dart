import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../movies/data/models/movie_model.dart';
import 'home_remote_data_source.dart';

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl({ApiClient? apiClient})
      : apiClient = apiClient ?? ApiClient();

  @override
  Future<List<MovieModel>> getHomeMovies() async {
    final response = await apiClient.get(
      ApiConstants.popularMovies,
      queryParameters: {
        'page': 1,
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
  Future<List<MovieModel>> getMoviesByGenre(int genreId) async {
    final response = await apiClient.get(
      ApiConstants.discoverMovies,
      queryParameters: {
        'page': 1,
        'with_genres': genreId,
        'sort_by': 'popularity.desc',
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
}