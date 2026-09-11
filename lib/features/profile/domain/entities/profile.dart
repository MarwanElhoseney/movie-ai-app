class Profile {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String country;
  final String language;
  final bool notificationsEnabled;
  final String membership;

  const Profile({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber = '',
    this.country = '',
    this.language = 'English',
    this.notificationsEnabled = true,
    this.membership = 'Member',
  });
}
