import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});

  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<bool> checkEmailExists({required String email});

  Future<void> resetPassword({required String email});

  Future<void> logout();

  Future<User> signInWithGoogle();
}
