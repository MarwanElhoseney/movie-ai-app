import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_app/features/search/view/widgets/actor_tile.dart';
import 'package:movie_app/features/search/view/widgets/search_input.dart';
import 'package:movie_app/features/search/view/widgets/search_mode.dart';
import 'package:movie_app/features/search/view/widgets/search_option.dart';
import 'package:provider/provider.dart';

import '../../auth/domain/entities/user.dart';
import '../../movie_details/view/movie_details_screen.dart';
import '../../movies/domain/entities/movie.dart';
import '../../movies/view/widgets/movie_info_tile.dart';
import '../../wishlist/view/wishlist_provider.dart';
import '../data/repositories/search_repository_impl.dart';
import '../domain/entities/actor.dart';
import '../domain/entities/search_mode.dart';
import '../domain/usecases/search_actor.dart';
import '../domain/usecases/search_movies.dart';
import 'actor_movies_screen.dart';

class SearchScreen extends StatefulWidget {
  final SearchMode? initialMode;
  final User user;

  const SearchScreen({
    super.key,
    this.initialMode,
    required this.user,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();

  late final SearchMovies searchMovies;
  late final SearchActors searchActors;

  SearchMode? mode;

  Timer? _debounce;

  List<Movie> movieResults = [];
  List<Actor> actorResults = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    mode = widget.initialMode;

    final repository = SearchRepositoryImpl();

    searchMovies = SearchMovies(repository);
    searchActors = SearchActors(repository);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();

    super.dispose();
  }

  void _cancelSearch() {
    _debounce?.cancel();

    controller.clear();

    FocusScope.of(context).unfocus();

    setState(() {
      mode = null;
      movieResults = [];
      actorResults = [];
      isLoading = false;
    });
  }
  void _onTextChanged(String value) {
    _debounce?.cancel();

    final query = value.trim();

    if (query.isEmpty || mode == null) {
      setState(() {
        movieResults = [];
        actorResults = [];
        isLoading = false;
      });

      return;
    }

    _debounce = Timer(
      const Duration(milliseconds: 350),
          () => _search(query),
    );
  }

  Future<void> _search(String query) async {
    final currentMode = mode;

    if (currentMode == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      if (currentMode == SearchMode.movie) {
        final results = await searchMovies(query);

        if (!mounted) return;

        setState(() {
          movieResults = results;
          actorResults = [];
          isLoading = false;
        });
      } else {
        final results = await searchActors(query);

        if (!mounted) return;

        setState(() {
          actorResults = results;
          movieResults = [];
          isLoading = false;
        });
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        movieResults = [];
        actorResults = [];
        isLoading = false;
      });
    }
  }

  void _changeMode(SearchMode newMode) {
    Navigator.pop(context);

    setState(() {
      mode = newMode;
      movieResults = [];
      actorResults = [];
    });

    final query = controller.text.trim();

    if (query.isNotEmpty) {
      _search(query);
    }
  }

  void _showFilter() {
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
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Search by',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SearchOption(
                  icon: Icons.movie_outlined,
                  title: 'Movie',
                  selected: mode == SearchMode.movie,
                  onTap: () {
                    _changeMode(SearchMode.movie);
                  },
                ),
                SearchOption(
                  icon: Icons.person_outline,
                  title: 'Actor',
                  selected: mode == SearchMode.actor,
                  onTap: () {
                    _changeMode(SearchMode.actor);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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

  void _openActorMovies(Actor actor) {
    final wishlist = context.read<WishlistProvider>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return ActorMoviesScreen(
            actor: actor,
            wishlist: wishlist,
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
          padding: const EdgeInsets.fromLTRB(
            16,
            18,
            16,
            10,
          ),
          child: Column(
            children: [
              SearchInput(
                controller: controller,
                onChanged: _onTextChanged,
                onFilterTap: _showFilter,
                suffixIcon: mode == SearchMode.actor
                    ? Icons.person_outline
                    : Icons.movie_outlined,
                onCancel: _cancelSearch,
                hint: mode == SearchMode.actor
                    ? 'Search actor...'
                    : mode == SearchMode.movie
                    ? 'Search movie...'
                    : 'Search...',
              ),
              const SizedBox(height: 22),
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (mode == null) {
      return _buildChooseMode();
    }

    if (controller.text.trim().isEmpty) {
      return Center(
        child: Text(
          mode == SearchMode.movie
              ? 'Search for a movie'
              : 'Search for an actor',
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 10,
          ),
        ),
      );
    }

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF00D5E6),
        ),
      );
    }

    return mode == SearchMode.movie
        ? _buildMovieResults()
        : _buildActorResults();
  }

  Widget _buildChooseMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Search by',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SearchModeButton(
                icon: Icons.movie_outlined,
                title: 'Movie',
                onTap: () {
                  setState(() {
                    mode = SearchMode.movie;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SearchModeButton(
                icon: Icons.person_outline,
                title: 'Actor',
                onTap: () {
                  setState(() {
                    mode = SearchMode.actor;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMovieResults() {
    if (movieResults.isEmpty) {
      return _buildEmptyResult(
        'Find your movie by Type title\n, categories, years, etc',
      );
    }

    return ListView.separated(
      itemCount: movieResults.length,
      separatorBuilder: (_, __) {
        return const SizedBox(height: 12);
      },
      itemBuilder: (_, index) {
        final movie = movieResults[index];

        return MovieInfoTile(
          movie: movie,
          showHeart: false,
          onTap: () => _openMovieDetails(movie),
        );
      },
    );
  }

  Widget _buildActorResults() {
    if (actorResults.isEmpty) {
      return _buildEmptyResult(
        'Find your actors by Type name',
      );
    }

    return ListView.separated(
      itemCount: actorResults.length,
      separatorBuilder: (_, __) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (_, index) {
        final actor = actorResults[index];

        return ActorTile(
          actor: actor,
          onTap: () => _openActorMovies(actor),
        );
      },
    );
  }

  Widget _buildEmptyResult(String text) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/no-results 1.png',
            width: 75,
            height: 75,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}