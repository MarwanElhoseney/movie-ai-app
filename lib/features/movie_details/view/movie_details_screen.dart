import 'package:flutter/material.dart';
import 'package:movie_app/features/movie_details/view/widgets/circle_button.dart';
import 'package:movie_app/features/movie_details/view/widgets/info.dart';
import 'package:movie_app/features/movie_details/view/widgets/share_sheet.dart';
import 'package:movie_app/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:movie_app/features/movies/domain/entities/movie.dart';
import 'package:movie_app/features/movies/domain/entities/movie_credit.dart';
import 'package:movie_app/features/movies/domain/usecases/get_movie_credits.dart';
import 'package:movie_app/features/movies/domain/usecases/get_movie_details.dart';
import 'package:movie_app/features/wishlist/view/wishlist_provider.dart';
import 'package:provider/provider.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late final GetMovieDetails _getMovieDetails;
  late final GetMovieCredits _getMovieCredits;

  late Future<Movie> _movieDetailsFuture;
  late Future<List<MovieCredit>> _movieCreditsFuture;


  @override
  void initState() {
    super.initState();

    final repository = MovieRepositoryImpl();

    _getMovieDetails = GetMovieDetails(repository);
    _getMovieCredits = GetMovieCredits(repository);

    _loadMovieDetails();
    _loadMovieCredits();
  }

  void _loadMovieCredits() {
    _movieCreditsFuture = _getMovieCredits(
      widget.movie.id,
    );
  }

  void _loadMovieDetails() {
    _movieDetailsFuture = _getMovieDetails(
      widget.movie.id,
    );
  }

  Future<void> _refreshMovieDetails() async {
    setState(() {
      _loadMovieDetails();
      _loadMovieCredits();
    });

    await Future.wait([
      _movieDetailsFuture,
      _movieCreditsFuture,
    ]);
  }

  Widget _buildPersonPlaceholder() {
    return Container(
      width: 85,
      height: 100,
      color: const Color(0xFF2B2939),
      alignment: Alignment.center,
      child: const Icon(
        Icons.person_outline_rounded,
        color: Colors.white38,
        size: 30,
      ),
    );
  }

  void _showShareSheet(BuildContext context,
      Movie movie,) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          ShareSheet(
            movieTitle: movie.title,
            movieUrl: 'https://your-movie-app.com/movie/${movie.id}',
          ),
    );
  }

  Future<void> _toggleFavorite(BuildContext context,
      WishlistProvider wishlist,
      Movie movie,) async {
    try {
      await wishlist.toggleFavorite(movie);
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update wishlist'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WishlistProvider>(
      builder: (context, wishlist, _) {
        return FutureBuilder<Movie>(
          future: _movieDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingState();
            }

            if (snapshot.hasError) {
              return _buildErrorState();
            }

            final movie = snapshot.data ?? widget.movie;

            return _buildMovieDetails(
              context,
              wishlist,
              movie,
            );
          },
        );
      },
    );
  }

  Widget _buildMovieDetails(BuildContext context,
      WishlistProvider wishlist,
      Movie movie,) {
    final isFavorite = wishlist.isFavorite(movie.id);

    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF00D5E6),
          onRefresh: _refreshMovieDetails,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(
                    children: [
                      CircleButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      CircleButton(
                        icon: Icons.share_outlined,
                        onTap: () {
                          _showShareSheet(
                            context,
                            movie,
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      CircleButton(
                        icon: isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFavorite
                            ? const Color(0xFFFF5368)
                            : Colors.white70,
                        onTap: () {
                          _toggleFavorite(
                            context,
                            wishlist,
                            movie,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(35, 14, 35, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.network(
                      movie.posterUrl,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          height: 300,
                          color: const Color(0xFF2B2939),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.movie_outlined,
                            color: Colors.white54,
                            size: 35,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 25),
                  child: Column(
                    children: [
                      Text(
                        movie.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (movie.year.isNotEmpty)
                            Info(text: movie.year),

                          if (movie.duration.isNotEmpty) ...[
                            const _Divider(),
                            Info(text: movie.duration),
                          ],

                          if (movie.certification.isNotEmpty) ...[
                            const _Divider(),
                            Info(text: movie.certification),
                          ],

                          if (movie.genre.isNotEmpty) ...[
                            const _Divider(),
                            Info(text: movie.genre),
                          ],
                        ],
                      ),

                      const SizedBox(height: 9),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFB72B),
                            size: 16,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            movie.rating,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.play_arrow_rounded,
                            size: 20,
                          ),
                          label: const Text(
                            'Play',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xFFFFA51F),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(22),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Story Line',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        movie.description.isNotEmpty
                            ? movie.description
                            : 'No description available.',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 9,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Cast and Crew',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      FutureBuilder<List<MovieCredit>>(
                        future: _movieCreditsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState
                              .waiting) {
                            return const SizedBox(
                              height: 120,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF00D5E6),
                                ),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return const Text(
                              'Failed to load cast and crew.',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 9,
                              ),
                            );
                          }

                          final credits = snapshot.data ?? [];

                          if (credits.isEmpty) {
                            return const Text(
                              'No cast and crew available.',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 9,
                              ),
                            );
                          }

                          final cast = credits
                              .where((credit) => credit.character.isNotEmpty)
                              .take(10)
                              .toList();

                          return SizedBox(
                            height: 150,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: cast.length,
                              separatorBuilder: (_, __) {
                                return const SizedBox(width: 12);
                              },
                              itemBuilder: (context, index) {
                                final person = cast[index];

                                return SizedBox(
                                  width: 85,
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: person.profileUrl.isNotEmpty
                                            ? Image.network(
                                          person.profileUrl,
                                          width: 85,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) {
                                            return _buildPersonPlaceholder();
                                          },
                                        )
                                            : _buildPersonPlaceholder(),
                                      ),

                                      const SizedBox(height: 7),

                                      Text(
                                        person.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      const SizedBox(height: 3),

                                      Text(
                                        person.character,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Scaffold(
      backgroundColor: Color(0xFF1F1D2B),
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00D5E6),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white38,
              size: 40,
            ),
            const SizedBox(height: 10),
            const Text(
              'Something went wrong',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                setState(_loadMovieDetails);
              },
              child: const Text(
                'Try again',
                style: TextStyle(
                  color: Color(0xFF00D5E6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: Colors.white30,
        shape: BoxShape.circle,
      ),
    );
  }
}