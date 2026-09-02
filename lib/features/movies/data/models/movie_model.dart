import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  const MovieModel({
    required super.id,
    required super.title,
    required super.posterUrl,
    required super.backdropUrl,
    required super.year,
    required super.duration,
    required super.genre,
    required super.rating,
    required super.certification,
    required super.description,
    super.premium,
  });

  factory MovieModel.fromEntity(Movie movie) {
    return MovieModel(
      id: movie.id,
      title: movie.title,
      posterUrl: movie.posterUrl,
      backdropUrl: movie.backdropUrl,
      year: movie.year,
      duration: movie.duration,
      genre: movie.genre,
      rating: movie.rating,
      certification: movie.certification,
      description: movie.description,
      premium: movie.premium,
    );
  }

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      posterUrl: json['posterUrl'] as String? ?? '',
      backdropUrl: json['backdropUrl'] as String? ?? '',
      year: json['year'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      genre: json['genre'] as String? ?? '',
      rating: json['rating'] as String? ?? '',
      certification: json['certification'] as String? ?? '',
      description: json['description'] as String? ?? '',
      premium: json['premium'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterUrl': posterUrl,
      'backdropUrl': backdropUrl,
      'year': year,
      'duration': duration,
      'genre': genre,
      'rating': rating,
      'certification': certification,
      'description': description,
      'premium': premium,
    };
  }
}
