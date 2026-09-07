import 'package:flutter/material.dart';
import 'package:movie_app/features/movie_details/view/movie_details_screen.dart';
import 'package:movie_app/features/movies/domain/entities/movie.dart';
import 'package:movie_app/features/movies/view/widgets/movie_info_tile.dart';
import 'package:movie_app/features/search/data/repositories/search_repository_impl.dart';
import 'package:movie_app/features/search/domain/entities/actor.dart';
import 'package:movie_app/features/search/domain/usecases/get_actor_movies.dart';
import 'package:movie_app/features/wishlist/view/wishlist_provider.dart';
import 'package:provider/provider.dart';

class ActorMoviesScreen extends StatefulWidget {
  final Actor actor;
  final WishlistProvider wishlist;

  const ActorMoviesScreen({
    super.key,
    required this.actor,
    required this.wishlist,
  });

  @override
  State<ActorMoviesScreen> createState() => _ActorMoviesScreenState();
}

class _ActorMoviesScreenState extends State<ActorMoviesScreen> {
  late final GetActorMovies _getActorMovies;
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();

    final repository = SearchRepositoryImpl();

    _getActorMovies = GetActorMovies(repository);

    _moviesFuture = _getActorMovies(widget.actor.id);
  }

  void _openMovieDetails(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return ChangeNotifierProvider.value(
            value: widget.wishlist,
            child: MovieDetailsScreen(movie: movie),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1D2B),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.actor.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF00D5E6)),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Failed to load movies.',
                style: TextStyle(color: Colors.white54, fontSize: 10),
              ),
            );
          }

          final movies = snapshot.data ?? [];

          if (movies.isEmpty) {
            return const Center(
              child: Text(
                'No movies found for this actor.',
                style: TextStyle(color: Colors.white54, fontSize: 10),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
            itemCount: movies.length,
            separatorBuilder: (_, __) {
              return const SizedBox(height: 12);
            },
            itemBuilder: (context, index) {
              final movie = movies[index];

              return MovieInfoTile(
                movie: movie,
                showHeart: false,
                onTap: () => _openMovieDetails(movie),
              );
            },
          );
        },
      ),
    );
  }
}
