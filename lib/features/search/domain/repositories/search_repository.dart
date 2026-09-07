import '../../../movies/domain/entities/movie.dart';
import '../entities/actor.dart';

abstract class SearchRepository {
  Future<List<Movie>> searchMovies(String query);

  Future<List<Actor>> searchActors(String query);

  Future<List<Movie>> getActorMovies(String actorId);
}

