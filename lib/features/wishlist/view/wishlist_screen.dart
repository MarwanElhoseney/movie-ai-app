import 'package:flutter/material.dart';
import 'package:movie_app/features/wishlist/view/wishlist_empty.dart';
import 'package:movie_app/features/wishlist/view/wishlist_provider.dart';
import 'package:provider/provider.dart';

import '../../movie_details/view/movie_details_screen.dart';
import '../../movies/domain/entities/movie.dart';
import '../../movies/view/widgets/movie_info_tile.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  void _openMovieDetails(BuildContext context, Movie movie) {
    final wishlist = context.read<WishlistProvider>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return ChangeNotifierProvider.value(
            value: wishlist,
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white70,
                    size: 15,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Wishlist',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Expanded(
                child: Consumer<WishlistProvider>(
                  builder: (context, wishlist, _) {
                    final movies = wishlist.movies;

                    if (wishlist.isLoading && movies.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF00D5E6),
                        ),
                      );
                    }

                    if (movies.isEmpty) {
                      return RefreshIndicator(
                        color: const Color(0xFF00D5E6),
                        backgroundColor: const Color(0xFF292736),
                        onRefresh: wishlist.loadWishlist,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 250),
                            WishlistEmpty(),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: const Color(0xFF00D5E6),
                      backgroundColor: const Color(0xFF292736),
                      onRefresh: wishlist.loadWishlist,
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: movies.length,
                        separatorBuilder: (_, __) {
                          return const SizedBox(height: 12);
                        },
                        itemBuilder: (context, index) {
                          final movie = movies[index];

                          return Dismissible(
                            key: ValueKey(movie.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (_) async {
                              try {
                                await wishlist.removeMovie(movie.id);
                              } catch (_) {
                                if (!context.mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to remove movie'),
                                  ),
                                );
                              }
                            },
                            child: MovieInfoTile(
                              movie: movie,
                              isFavorite: wishlist.isFavorite(movie.id),
                              onFavoriteTap: () async {
                                try {
                                  await wishlist.toggleFavorite(movie);
                                } catch (_) {
                                  if (!context.mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Failed to update wishlist',
                                      ),
                                    ),
                                  );
                                }
                              },
                              onTap: () {
                                _openMovieDetails(context, movie);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
