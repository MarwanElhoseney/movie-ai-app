import '../models/movie_model.dart';
import 'movie_local_data_source.dart';

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  @override
  Future<List<MovieModel>> getMovies() async {
    return const [
      MovieModel(
        id: '1',
        title: 'Spider-Man No Way Home',
        posterUrl:
            'https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg',
        backdropUrl:
            'https://image.tmdb.org/t/p/w1280/14QbnygCuTO0vl7CAFmPf1fgZfV.jpg',
        year: '2021',
        duration: '148 Minutes',
        genre: 'Action',
        rating: '4.5',
        certification: 'PG-13',
        description:
            'For the first time in the cinematic history of Spider-Man, '
            'our friendly neighborhood hero’s identity is revealed, bringing '
            'his world into conflict with powerful enemies.',
        premium: true,
      ),
      MovieModel(
        id: '2',
        title: 'Riverdale',
        posterUrl:
            'https://image.tmdb.org/t/p/w500/1a4G7pJ3xD4Y8kG2GmM9f2uK0Jm.jpg',
        backdropUrl:
            'https://image.tmdb.org/t/p/w1280/8s4h9friP6Ci3adRGmWIV2H1F4W.jpg',
        year: '2022',
        duration: '148 Minutes',
        genre: 'Drama',
        rating: '4.2',
        certification: 'PG-13',
        description:
            'A group of teenagers discovers the mysteries and secrets '
            'hidden beneath the surface of their seemingly peaceful town.',
      ),
      MovieModel(
        id: '3',
        title: 'Life of Pi',
        posterUrl:
            'https://image.tmdb.org/t/p/w500/mYDKm8g3ANdcAQ1bV1tQ7zvK4bA.jpg',
        backdropUrl:
            'https://image.tmdb.org/t/p/w1280/8T5y2gJ0n9Q8s7f4z9qY4jK5c6L.jpg',
        year: '2021',
        duration: '128 Minutes',
        genre: 'Adventure',
        rating: '4.4',
        certification: 'PG-13',
        description:
            'A young man survives a disaster at sea and begins an '
            'extraordinary journey that changes his life forever.',
        premium: true,
      ),
      MovieModel(
        id: '4',
        title: 'The Jungle Waiting',
        posterUrl:
            'https://image.tmdb.org/t/p/w500/8Q2fY4zJ0c4kP3b1m9f0v7g2w1H.jpg',
        backdropUrl:
            'https://image.tmdb.org/t/p/w1280/3Q4v8f2J9m1x6z7n0p5k2c4d8sA.jpg',
        year: '2022',
        duration: '116 Minutes',
        genre: 'Action',
        rating: '4.1',
        certification: 'PG-13',
        description:
            'An unexpected journey through a dangerous jungle forces '
            'a group of friends to work together to survive.',
      ),
      MovieModel(
        id: '5',
        title: 'Movie Datecase',
        posterUrl:
            'https://image.tmdb.org/t/p/w500/9q2f5g7h1j3k8m0n4p6r2s5t7v.jpg',
        backdropUrl:
            'https://image.tmdb.org/t/p/w1280/7v5t3r2p1n8m6k4j9h0g2f5d1s.jpg',
        year: '2023',
        duration: '104 Minutes',
        genre: 'Comedy',
        rating: '4.0',
        certification: 'PG-13',
        description:
            'A lighthearted story about friendship, movies and an '
            'unexpected night that goes completely off script.',
      ),
    ];
  }
}
