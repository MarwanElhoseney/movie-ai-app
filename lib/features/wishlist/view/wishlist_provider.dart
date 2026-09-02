import 'package:flutter/foundation.dart';

import '../../movies/domain/entities/movie.dart';
import '../data/repositories/wishlist_repository_impl.dart';
import '../domain/repositories/wishlist_repository.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistRepository repository;
  final String userId;

  WishlistProvider({required this.userId, WishlistRepository? repository})
    : repository = repository ?? WishlistRepositoryImpl();

  final Map<String, Movie> _movies = {};

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Movie> get movies => _movies.values.toList();

  bool isFavorite(String movieId) {
    return _movies.containsKey(movieId);
  }

  Future<void> loadWishlist() async {
    _isLoading = true;
    notifyListeners();

    try {
      final wishlist = await repository.getWishlist(userId);

      _movies
        ..clear()
        ..addEntries(wishlist.map((movie) => MapEntry(movie.id, movie)));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Movie movie) async {
    final favorite = isFavorite(movie.id);

    if (favorite) {
      await removeMovie(movie.id);
      return;
    }

    await repository.add(userId: userId, movie: movie);

    _movies[movie.id] = movie;

    notifyListeners();
  }

  Future<void> removeMovie(String movieId) async {
    if (!isFavorite(movieId)) return;

    await repository.remove(userId: userId, movieId: movieId);

    _movies.remove(movieId);

    notifyListeners();
  }
}
