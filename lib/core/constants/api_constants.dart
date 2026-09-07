class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';

  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  static const String popularMovies = '/movie/popular';

  static const String discoverMovies = '/discover/movie';

  static const String searchMovies = '/search/movie';

  static const String searchActors = '/search/person';

  static String movieDetails(String movieId) {
    return '/movie/$movieId';
  }

  static String movieReleaseDates(String movieId) {
    return '/movie/$movieId/release_dates';
  }

  static String movieCredits(String movieId) {
    return '/movie/$movieId/credits';
  }

  static String actorMovieCredits(String actorId) {
    return '/person/$actorId/movie_credits';
  }
}
