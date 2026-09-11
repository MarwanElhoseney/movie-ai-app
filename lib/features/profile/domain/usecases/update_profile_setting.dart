import '../repositories/profile_repository.dart';

class UpdateProfileSetting {
  final ProfileRepository repository;

  UpdateProfileSetting(this.repository);

  Future<void> call({
    required String userId,
    String? language,
    String? country,
    bool? notificationsEnabled,
  }) {
    return repository.updateSetting(
      userId: userId,
      language: language,
      country: country,
      notificationsEnabled: notificationsEnabled,
    );
  }
}
