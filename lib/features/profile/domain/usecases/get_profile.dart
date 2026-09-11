import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class GetProfile {
  final ProfileRepository repository;

  GetProfile(this.repository);

  Future<Profile> call(String userId) {
    return repository.getProfile(userId);
  }
}
