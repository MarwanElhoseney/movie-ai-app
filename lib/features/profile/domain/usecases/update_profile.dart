import '../repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<void> call({
    required String userId,
    required String name,
    required String email,
    required String phoneNumber,
  }) {
    return repository.updateProfile(
      userId: userId,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}
