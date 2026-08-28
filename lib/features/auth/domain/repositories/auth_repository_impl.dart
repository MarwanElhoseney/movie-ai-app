import '../../data/datasources/auth_remote_data_source.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({AuthRemoteDataSource? remoteDataSource})
    : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSource();

  @override
  Future<User> login({required String email, required String password}) async {
    final credential = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user!;

    return User(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? '',
      email: firebaseUser.email ?? email,
    );
  }

  @override
  Future<User> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _remoteDataSource.signUp(
      email: email,
      password: password,
      name: name,
    );

    final firebaseUser = credential.user!;

    return User(
      id: firebaseUser.uid,
      name: name,
      email: firebaseUser.email ?? email,
    );
  }

  @override
  Future<bool> checkEmailExists({required String email}) async {
    return await _remoteDataSource.checkEmailExists(email: email);
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _remoteDataSource.resetPassword(email: email);
  }

  @override
  Future<void> logout() async {
    await _remoteDataSource.logout();
  }
}
