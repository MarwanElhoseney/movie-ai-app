import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> login({
    required String email,
    required String password,
  });

  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<UserCredential> signInWithGoogle();

  Future<void> resetPassword({
    required String email,
  });

  Future<bool> checkEmailExists({
    required String email,
  });

  Future<void> logout();
}