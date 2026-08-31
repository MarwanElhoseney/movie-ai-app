import '../repositories/auth_repository.dart';

class ResetPassword {
  final AuthRepository repository;

  ResetPassword(this.repository);

  Future<void> call({
    required String email,
  }) {
    return repository.resetPassword(
      email: email,
    );
  }
}