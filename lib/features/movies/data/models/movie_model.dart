import '../../../../core/constants/api_constants.dart';
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

  // Firestore
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

  // TMDB - Popular Movies
  factory MovieModel.fromTmdbJson(Map<String, dynamic> json) {
    final posterPath = json['poster_path'] as String?;
    final backdropPath = json['backdrop_path'] as String?;
    final releaseDate = json['release_date'] as String?;
    final voteAverage = (json['vote_average'] as num?)?.toDouble() ?? 0.0;

    return MovieModel(
      id: (json['id'] as num?)?.toString() ?? '',
      title: json['title'] as String? ?? '',
      posterUrl: posterPath != null
          ? '${ApiConstants.imageBaseUrl}$posterPath'
          : '',
      backdropUrl: backdropPath != null
          ? '${ApiConstants.imageBaseUrl}$backdropPath'
          : '',
      year: releaseDate != null && releaseDate.length >= 4
          ? releaseDate.substring(0, 4)
          : '',
      duration: '',
      genre: '',
      rating: voteAverage.toStringAsFixed(1),
      certification: '',
      description: json['overview'] as String? ?? '',
      premium: false,
    );
  }

  // TMDB - Movie Details
  factory MovieModel.fromTmdbDetailsJson(Map<String, dynamic> json,) {
    final posterPath = json['poster_path'] as String?;
    final backdropPath = json['backdrop_path'] as String?;
    final releaseDate = json['release_date'] as String?;

    final voteAverage =
        (json['vote_average'] as num?)?.toDouble() ?? 0.0;

    final runtime = json['runtime'] as int?;

    final genres = (json['genres'] as List<dynamic>? ?? [])
        .map(
          (genre) => genre['name'] as String? ?? '',
    )
        .where(
          (name) => name.isNotEmpty,
    )
        .join(', ');

    return MovieModel(
      id: (json['id'] as num?)?.toString() ?? '',
      title: json['title'] as String? ?? '',
      posterUrl: posterPath != null
          ? '${ApiConstants.imageBaseUrl}$posterPath'
          : '',
      backdropUrl: backdropPath != null
          ? '${ApiConstants.imageBaseUrl}$backdropPath'
          : '',
      year: releaseDate != null && releaseDate.length >= 4
          ? releaseDate.substring(0, 4)
          : '',
      duration: runtime != null
          ? '$runtime min'
          : '',
      genre: genres,
      rating: voteAverage.toStringAsFixed(1),
      certification: '',
      description: json['overview'] as String? ?? '',
      premium: false,
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