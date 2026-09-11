import '../../domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.phoneNumber,
    super.country,
    super.language,
    super.notificationsEnabled,
    super.membership,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map, {required String id}) {
    return ProfileModel(
      id: id,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      country: map['country'] as String? ?? '',
      language: map['language'] as String? ?? 'English',
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      membership: map['membership'] as String? ?? 'Member',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'country': country,
      'language': language,
      'notificationsEnabled': notificationsEnabled,
      'membership': membership,
    };
  }
}
