import '../entities/actor.dart';
import '../repositories/search_repository.dart';

class SearchActors {
  final SearchRepository repository;

  const SearchActors(this.repository);

  Future<List<Actor>> call(String query) {
    return repository.searchActors(query);
  }
}
