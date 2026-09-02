import '../../../movies/domain/entities/movie.dart';
import '../repositories/search_repository.dart';

class SearchMovies {
  final SearchRepository repository;

  const SearchMovies(this.repository);

  Future<List<Movie>> call(String query) {
    return repository.searchMovies(query);
  }
}
