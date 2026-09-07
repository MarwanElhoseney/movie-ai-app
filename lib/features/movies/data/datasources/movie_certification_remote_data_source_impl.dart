import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import 'movie_certification_remote_data_source.dart';

class MovieCertificationRemoteDataSourceImpl
    implements MovieCertificationRemoteDataSource {
  final ApiClient apiClient;

  MovieCertificationRemoteDataSourceImpl({ApiClient? apiClient})
    : apiClient = apiClient ?? ApiClient();

  @override
  Future<String> getMovieCertification(String movieId) async {
    final response = await apiClient.get(
      ApiConstants.movieReleaseDates(movieId),
    );

    final results = response.data['results'] as List<dynamic>? ?? [];

    for (final result in results) {
      final resultMap = result as Map<String, dynamic>;

      // هنستخدم تصنيف الولايات المتحدة
      if (resultMap['iso_3166_1'] != 'US') {
        continue;
      }

      final releaseDates = resultMap['release_dates'] as List<dynamic>? ?? [];

      for (final release in releaseDates) {
        final releaseMap = release as Map<String, dynamic>;

        final certification = releaseMap['certification'] as String? ?? '';

        if (certification.isNotEmpty) {
          return certification;
        }
      }
    }

    return '';
  }
}
