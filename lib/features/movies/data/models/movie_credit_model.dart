import 'package:movie_app/core/constants/api_constants.dart';

import '../../domain/entities/movie_credit.dart';

class MovieCreditModel extends MovieCredit {
  const MovieCreditModel({
    required super.id,
    required super.name,
    required super.character,
    required super.profileUrl,
    required super.job,
  });

  factory MovieCreditModel.fromTmdbCastJson(Map<String, dynamic> json) {
    final profilePath = json['profile_path'] as String?;

    return MovieCreditModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      character: json['character'] as String? ?? '',
      profileUrl: profilePath != null
          ? '${ApiConstants.imageBaseUrl}$profilePath'
          : '',
      job: '',
    );
  }

  factory MovieCreditModel.fromTmdbCrewJson(Map<String, dynamic> json) {
    final profilePath = json['profile_path'] as String?;

    return MovieCreditModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      character: '',
      profileUrl: profilePath != null
          ? '${ApiConstants.imageBaseUrl}$profilePath'
          : '',
      job: json['job'] as String? ?? '',
    );
  }
}
