import '../../../movies/data/models/movie_model.dart';

abstract class ActorMoviesRemoteDataSource {
  Future<List<MovieModel>> getActorMovies(String actorId);
}
