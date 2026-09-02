import 'package:flutter/material.dart';

import '../../../movies/domain/entities/movie.dart';
import '../../../movies/view/widgets/movie_poster.dart';

class PopularMovies extends StatelessWidget {
  final List<Movie> movies;
  final ValueChanged<Movie> onMovieTap;

  const PopularMovies({
    super.key,
    required this.movies,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final movie = movies[index];

          return SizedBox(
            width: 100,
            child: GestureDetector(
              onTap: () => onMovieTap(movie),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      MoviePoster(movie: movie, width: 100, height: 145),
                      Positioned(
                        right: 5,
                        top: 5,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFB72B),
                              size: 12,
                            ),
                            Text(
                              movie.rating,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 8),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
