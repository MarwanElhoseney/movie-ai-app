import 'package:flutter/material.dart';
import 'package:movie_app/features/home/view/widgets/category_list.dart';
import 'package:movie_app/features/home/view/widgets/featured_movie.dart';
import 'package:movie_app/features/home/view/widgets/home_header.dart';
import 'package:movie_app/features/home/view/widgets/popular_movies.dart';
import 'package:movie_app/features/home/view/widgets/search_preview.dart';
import 'package:provider/provider.dart';
import '../../auth/domain/entities/user.dart';
import '../../movie_details/view/movie_details_screen.dart';
import '../../movies/domain/entities/movie.dart';
import '../../movies/view/widgets/movie_info_tile.dart';
import '../../search/domain/entities/search_mode.dart';
import '../../search/view/search_screen.dart';
import '../../wishlist/view/wishlist_provider.dart';
import '../data/repositories/home_repository_impl.dart';
import '../domain/usecases/get_home_movies.dart';


class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({
    super.key,
    required this.user,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> _moviesFuture;

  late final GetHomeMovies _getHomeMovies;

  @override
  void initState() {
    super.initState();

    _getHomeMovies = GetHomeMovies(
      HomeRepositoryImpl(),
    );

    _loadMovies();
  }

  void _loadMovies() {
    _moviesFuture = _getHomeMovies();
  }

  Future<void> _refreshMovies() async {
    setState(_loadMovies);

    await _moviesFuture;
  }

  void _openMovieDetails(Movie movie) {
    final wishlist = context.read<WishlistProvider>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return ChangeNotifierProvider.value(
            value: wishlist,
            child: MovieDetailsScreen(
              movie: movie,
            ),
          );
        },
      ),
    );
  }

  void _openSearch({SearchMode? mode}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            SearchScreen(
              initialMode: mode,
              user: widget.user,
            ),
      ),
    );
  }

  void _showSearchFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF292736),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Search by',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 15),
                ListTile(
                  leading: const Icon(
                    Icons.movie_outlined,
                    color: Color(0xFF00D5E6),
                  ),
                  title: const Text(
                    'Movie',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _openSearch(
                      mode: SearchMode.movie,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF00D5E6),
                  ),
                  title: const Text(
                    'Actor',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _openSearch(
                      mode: SearchMode.actor,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      body: SafeArea(
        child: FutureBuilder<List<Movie>>(
          future: _moviesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF00D5E6),
                ),
              );
            }

            if (snapshot.hasError) {
              return _buildErrorState();
            }

            final movies = snapshot.data ?? [];

            if (movies.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              color: const Color(0xFF00D5E6),
              onRefresh: _refreshMovies,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      12,
                      16,
                      25,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        HomeHeader(
                          user: widget.user,
                          onProfileTap: () {},
                          onWishlistTap: () {},
                        ),

                        const SizedBox(height: 18),

                        SearchPreview(
                          onTap: () => _openSearch(),
                          onFilterTap: _showSearchFilter,
                        ),

                        const SizedBox(height: 18),

                        FeaturedMovie(
                          movie: movies.first,
                          onTap: () =>
                              _openMovieDetails(
                                movies.first,
                              ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Categories',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 10),

                        CategoryList(
                          categories: const [
                            'All',
                            'Comedy',
                            'Animation',
                            'Documentary',
                            'Action',
                          ],
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            const Text(
                              'Most popular',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'See All',
                                style: TextStyle(
                                  color: Color(0xFF00D5E6),
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        PopularMovies(
                          movies: movies,
                          onMovieTap: _openMovieDetails,
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Recommended for you',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        ...movies.take(3).map(
                              (movie) =>
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 12,
                                ),
                                child: MovieInfoTile(
                                  movie: movie,
                                  showHeart: false,
                                  onTap: () =>
                                      _openMovieDetails(
                                        movie,
                                      ),
                                ),
                              ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
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
              setState(_loadMovies);
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
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        'No movies available',
        style: TextStyle(
          color: Colors.white38,
          fontSize: 11,
        ),
      ),
    );
  }
}