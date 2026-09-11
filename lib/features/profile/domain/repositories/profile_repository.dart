import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile(String userId);

  Future<bool> isNameTaken({
    required String name,
    required String currentUserId,
  });

  Future<void> updateProfile({
    required String userId,
    required String name,
    required String email,
    required String phoneNumber,
  });

  Future<void> updateSetting({
    required String userId,
    String? language,
    String? country,
    bool? notificationsEnabled,
  });
}
