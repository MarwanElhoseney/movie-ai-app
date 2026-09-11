import 'package:flutter/material.dart';

import '../../auth/domain/entities/user.dart';
import '../../auth/domain/repositories/auth_repository_impl.dart';
import '../../auth/view/auth_screen.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/entities/profile.dart';
import '../domain/usecases/get_profile.dart';
import '../domain/usecases/update_profile_setting.dart';
import 'about_us_screen.dart';
import 'change_password_screen.dart';
import 'country_screen.dart';
import 'edit_profile_screen.dart';
import 'help_feedback_screen.dart';
import 'language_screen.dart';
import 'legal_policies_screen.dart';
import 'membership_screen.dart';
import 'notification_screen.dart';
import 'widgets/premium_card.dart';
import 'widgets/profile_menu_item.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  final ValueChanged<User>? onUserUpdated;

  const ProfileScreen({super.key, required this.user, this.onUserUpdated});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final GetProfile _getProfile;
  late final UpdateProfileSetting _updateSetting;

  late Future<Profile> _profileFuture;
  late final AuthRepositoryImpl _authRepository;

  @override
  void initState() {
    super.initState();

    final repository = ProfileRepositoryImpl();

    _getProfile = GetProfile(repository);
    _updateSetting = UpdateProfileSetting(repository);

    _authRepository = AuthRepositoryImpl();

    _loadProfile();
  }

  void _loadProfile() {
    _profileFuture = _getProfile(widget.user.id);
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF292736),
          title: Column(
            children: [
              Center(child: Image.asset("assets/images/Question.png")),
              const Text(
                'Are you sure?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Text(
            'Do you really want to log out?',
            style: TextStyle(color: Colors.white60, fontSize: 11),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white54),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text(
                'Log Out',
                style: TextStyle(color: Color(0xFF00D5E6)),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) return;

    try {
      await _authRepository.logout();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to log out')));
    }
  }

  Future<void> _openEditProfile(Profile profile) async {
    final updatedProfile = await Navigator.push<Profile>(
      context,
      MaterialPageRoute(builder: (_) => EditProfileScreen(profile: profile)),
    );

    if (!mounted) return;

    if (updatedProfile != null) {
      final updatedUser = User(
        id: updatedProfile.id,
        name: updatedProfile.name,
        email: updatedProfile.email,
      );

      widget.onUserUpdated?.call(updatedUser);

      setState(() {
        _profileFuture = Future.value(updatedProfile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      body: SafeArea(
        child: FutureBuilder<Profile>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF00D5E6)),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Unable to load profile',
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              );
            }

            final profile =
                snapshot.data ??
                Profile(
                  id: widget.user.id,
                  name: widget.user.name,
                  email: widget.user.email,
                );

            return RefreshIndicator(
              color: const Color(0xFF00D5E6),
              onRefresh: () async {
                setState(_loadProfile);
                await _profileFuture;
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 25),
                children: [
                  _buildHeader(profile),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MembershipScreen(),
                        ),
                      );
                    },
                    child: const PremiumCard(),
                  ),
                  const SizedBox(height: 22),
                  _sectionTitle('Account'),
                  const SizedBox(height: 9),
                  ProfileMenuItem(
                    icon: Icons.person_outline,
                    title: 'Membership',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MembershipScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ProfileMenuItem(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle('General'),
                  const SizedBox(height: 9),
                  ProfileMenuItem(
                    icon: Icons.notifications_none,
                    title: 'Notification',
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotificationScreen(
                            profile: profile,
                            updateSetting: _updateSetting,
                          ),
                        ),
                      );

                      if (!mounted) return;

                      setState(_loadProfile);
                    },
                  ),
                  const SizedBox(height: 8),
                  ProfileMenuItem(
                    icon: Icons.language,
                    title: 'Language',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          profile.language,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 8,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF00D5E6),
                          size: 18,
                        ),
                      ],
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LanguageScreen(
                            profile: profile,
                            updateSetting: _updateSetting,
                          ),
                        ),
                      );

                      if (!mounted) return;

                      setState(_loadProfile);
                    },
                  ),
                  const SizedBox(height: 8),
                  ProfileMenuItem(
                    icon: Icons.public,
                    title: 'Country',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          profile.country.isEmpty ? 'Select' : profile.country,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 8,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF00D5E6),
                          size: 18,
                        ),
                      ],
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CountryScreen(
                            profile: profile,
                            updateSetting: _updateSetting,
                          ),
                        ),
                      );

                      if (!mounted) return;

                      setState(_loadProfile);
                    },
                  ),
                  const SizedBox(height: 8),
                  ProfileMenuItem(
                    icon: Icons.delete_sweep_outlined,
                    title: 'Clear Cache',
                    onTap: _clearCache,
                  ),
                  const SizedBox(height: 20),
                  _sectionTitle('More'),
                  const SizedBox(height: 9),
                  ProfileMenuItem(
                    icon: Icons.gavel_outlined,
                    title: 'Legal and Policies',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LegalPoliciesScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ProfileMenuItem(
                    icon: Icons.help_outline,
                    title: 'Help & Feedback',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const HelpFeedbackScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  ProfileMenuItem(
                    icon: Icons.info_outline,
                    title: 'About Us',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AboutUsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _logout,
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF00D5E6)),
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(
                          color: Color(0xFF00D5E6),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(Profile profile) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFF373545),
          child: Text(
            profile.name.isEmpty ? '?' : profile.name[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                profile.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white54, fontSize: 8),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => _openEditProfile(profile),
          child: const Icon(
            Icons.edit_outlined,
            color: Color(0xFF00D5E6),
            size: 16,
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _clearCache() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cache cleared successfully')));
  }
}
