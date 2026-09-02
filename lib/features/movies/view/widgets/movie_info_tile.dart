import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';
import 'movie_poster.dart';

class MovieInfoTile extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  final bool showHeart;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;

  const MovieInfoTile({
    super.key,
    required this.movie,
    this.onTap,
    this.showHeart = true,
    this.isFavorite = false,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MoviePoster(movie: movie, width: 82, height: 112, onTap: onTap),

          const SizedBox(width: 10),

          Expanded(
            child: SizedBox(
              height: 112,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MovieTag(
                    text: movie.premium ? 'Premium' : 'Free',
                    color: movie.premium
                        ? const Color(0xFFFF9E2C)
                        : const Color(0xFF12D7E6),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  _MovieMeta(
                    text: movie.year,
                    icon: Icons.calendar_today_outlined,
                  ),

                  _MovieMeta(text: movie.duration, icon: Icons.access_time),

                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFFFB72B),
                        size: 13,
                      ),

                      const SizedBox(width: 2),

                      Text(
                        movie.rating,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 9,
                        ),
                      ),

                      const SizedBox(width: 7),

                      Expanded(
                        child: Text(
                          movie.genre,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 8,
                          ),
                        ),
                      ),

                      const SizedBox(width: 5),

                      _MovieTag(
                        text: movie.certification,
                        color: const Color(0xFF00B8CA),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          if (showHeart && onFavoriteTap != null)
            GestureDetector(
              onTap: onFavoriteTap,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFavorite ? const Color(0xFFFF5368) : Colors.white70,
                  size: 17,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MovieMeta extends StatelessWidget {
  final String text;
  final IconData icon;

  const _MovieMeta({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Icon(icon, color: Colors.white38, size: 10),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(color: Colors.white54, fontSize: 8),
          ),
        ],
      ),
    );
  }
}

class _MovieTag extends StatelessWidget {
  final String text;
  final Color color;

  const _MovieTag({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(.9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 6.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
