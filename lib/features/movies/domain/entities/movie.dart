class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final String year;
  final String duration;
  final String genre;
  final String rating;
  final String certification;
  final String description;
  final bool premium;

  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.backdropUrl,
    required this.year,
    required this.duration,
    required this.genre,
    required this.rating,
    required this.certification,
    required this.description,
    this.premium = false,
  });
}
