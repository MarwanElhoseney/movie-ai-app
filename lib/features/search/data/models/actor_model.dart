import 'package:movie_app/core/constants/api_constants.dart';

import '../../domain/entities/actor.dart';

class ActorModel extends Actor {
  const ActorModel({
    required super.id,
    required super.name,
    required super.imageUrl,
  });

  factory ActorModel.fromEntity(Actor actor) {
    return ActorModel(
      id: actor.id,
      name: actor.name,
      imageUrl: actor.imageUrl,
    );
  }

  // Firestore / Local
  factory ActorModel.fromJson(Map<String, dynamic> json) {
    return ActorModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  // TMDB - Search Person
  factory ActorModel.fromTmdbJson(Map<String, dynamic> json,) {
    final profilePath = json['profile_path'] as String?;

    return ActorModel(
      id: (json['id'] as num?)?.toString() ?? '',
      name: json['name'] as String? ?? '',
      imageUrl: profilePath != null
          ? '${ApiConstants.imageBaseUrl}$profilePath'
          : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}