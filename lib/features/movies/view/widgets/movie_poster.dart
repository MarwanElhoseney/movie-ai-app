import 'package:flutter/material.dart';

import '../../domain/entities/movie.dart';

class MoviePoster extends StatelessWidget {
  final Movie movie;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const MoviePoster({
    super.key,
    required this.movie,
    this.width = 100,
    this.height = 145,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final poster = ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: Image.network(
        movie.posterUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: width,
            height: height,
            color: const Color(0xFF2B2939),
            alignment: Alignment.center,
            child: const Icon(Icons.movie_outlined, color: Colors.white54),
          );
        },
      ),
    );

    if (onTap == null) {
      return poster;
    }

    return GestureDetector(onTap: onTap, child: poster);
  }
}
