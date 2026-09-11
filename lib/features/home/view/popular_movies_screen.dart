import 'package:flutter/material.dart';

import '../../movie_details/view/movie_details_screen.dart';
import '../../movies/domain/entities/movie.dart';
import '../../movies/view/widgets/movie_info_tile.dart';

class PopularMoviesScreen extends StatelessWidget {
  final List<Movie> movies;

  const PopularMoviesScreen({super.key, required this.movies});

  void _openMovieDetails(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MovieDetailsScreen(movie: movie)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1D2B),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Most Popular',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: movies.isEmpty
          ? const Center(
              child: Text(
                'No movies found',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: MovieInfoTile(
                    movie: movie,
                    showHeart: false,
                    onTap: () => _openMovieDetails(context, movie),
                  ),
                );
              },
            ),
    );
  }
}
