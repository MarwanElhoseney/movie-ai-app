import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../datasources/profile_remote_data_source_impl.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource dataSource;

  ProfileRepositoryImpl({ProfileRemoteDataSource? dataSource})
    : dataSource = dataSource ?? ProfileRemoteDataSourceImpl();

  @override
  Future<Profile> getProfile(String userId) {
    return dataSource.getProfile(userId);
  }

  @override
  Future<bool> isNameTaken({
    required String name,
    required String currentUserId,
  }) {
    return dataSource.isNameTaken(name: name, currentUserId: currentUserId);
  }

  @override
  Future<void> updateProfile({
    required String userId,
    required String name,
    required String email,
    required String phoneNumber,
  }) {
    return dataSource.updateProfile(
      userId: userId,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
    );
  }

  @override
  Future<void> updateSetting({
    required String userId,
    String? language,
    String? country,
    bool? notificationsEnabled,
  }) {
    return dataSource.updateSetting(
      userId: userId,
      language: language,
      country: country,
      notificationsEnabled: notificationsEnabled,
    );
  }
}
