import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../movies/data/models/movie_model.dart';
import 'actor_movies_remote_data_source.dart';

class ActorMoviesRemoteDataSourceImpl
    implements ActorMoviesRemoteDataSource {
  final ApiClient apiClient;

  ActorMoviesRemoteDataSourceImpl({ApiClient? apiClient})
      : apiClient = apiClient ?? ApiClient();

  @override
  Future<List<MovieModel>> getActorMovies(String actorId) async {
    final response = await apiClient.get(
      ApiConstants.actorMovieCredits(actorId),
    );

    final data = response.data as Map<String, dynamic>;

    final cast = data['cast'] as List<dynamic>? ?? [];

    return cast
        .map(
          (json) =>
          MovieModel.fromTmdbJson(
            json as Map<String, dynamic>,
          ),
    )
        .where((movie) => movie.id.isNotEmpty)
        .toList();
  }
}