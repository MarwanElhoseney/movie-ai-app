import '../../../movies/data/models/movie_model.dart';
import '../models/actor_model.dart';

abstract class SearchLocalDataSource {
  Future<List<MovieModel>> searchMovies(String query);

  Future<List<ActorModel>> searchActors(String query);
}
