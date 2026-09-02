import '../../../movies/data/datasources/movie_local_data_source.dart';
import '../../../movies/data/datasources/movie_local_data_source_impl.dart';
import '../../../movies/data/models/movie_model.dart';
import '../models/actor_model.dart';
import 'search_local_data_source.dart';

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final MovieLocalDataSource movieDataSource;

  SearchLocalDataSourceImpl({MovieLocalDataSource? movieDataSource})
    : movieDataSource = movieDataSource ?? MovieLocalDataSourceImpl();

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final value = query.trim().toLowerCase();

    if (value.isEmpty) {
      return [];
    }

    final movies = await movieDataSource.getMovies();

    return movies
        .where((movie) => movie.title.toLowerCase().contains(value))
        .toList();
  }

  @override
  Future<List<ActorModel>> searchActors(String query) async {
    final value = query.trim().toLowerCase();

    if (value.isEmpty) {
      return [];
    }

    const actors = [
      ActorModel(id: '1', name: 'Tom Holland', imageUrl: ''),
      ActorModel(id: '2', name: 'Tom Hanks', imageUrl: ''),
      ActorModel(id: '3', name: 'Tom Hardy', imageUrl: ''),
      ActorModel(id: '4', name: 'Zendaya', imageUrl: ''),
      ActorModel(id: '5', name: 'Andrew Garfield', imageUrl: ''),
      ActorModel(id: '6', name: 'Robert Downey Jr.', imageUrl: ''),
    ];

    return actors
        .where((actor) => actor.name.toLowerCase().contains(value))
        .toList();
  }
}
