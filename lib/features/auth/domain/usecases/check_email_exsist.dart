import '../repositories/auth_repository.dart';

class CheckEmailExists {
  final AuthRepository repository;

  CheckEmailExists(this.repository);

  Future<bool> call({required String email}) async {
    return await repository.checkEmailExists(email: email);
  }
}
