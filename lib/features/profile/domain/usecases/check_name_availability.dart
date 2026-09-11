import '../repositories/profile_repository.dart';

class CheckNameAvailability {
  final ProfileRepository repository;

  CheckNameAvailability(this.repository);

  Future<bool> call({required String name, required String currentUserId}) {
    return repository.isNameTaken(name: name, currentUserId: currentUserId);
  }
}
