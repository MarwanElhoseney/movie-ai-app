import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/tmdb_settings.dart';
import '../../core/navigation/main_shell/view/main_shell.dart';
import '../../core/network/tmdb_preferences.dart';
import '../auth/domain/entities/user.dart' as app_user;
import '../onboarding/view/onboarding_screen.dart';
import '../profile/data/repositories/profile_repository_impl.dart';
import '../profile/domain/usecases/get_profile.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    final firebaseUser =
        firebase_auth.FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      try {
        await _loadTmdbPreferences(firebaseUser.uid);
      } catch (e) {
        // لو فشل تحميل الـ Profile، هنكمل بالقيم الافتراضية.
      }

      if (!mounted) return;

      final user = app_user.User(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? '',
        email: firebaseUser.email ?? '',
      );

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context,
              animation,
              secondaryAnimation,) {
            return MainShell(
              user: user,
            );
          },
          transitionsBuilder: (context,
              animation,
              secondaryAnimation,
              child,) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),

          pageBuilder: (context,
              animation,
              secondaryAnimation,) {
            return const OnboardingScreen();
          },

          transitionsBuilder: (context,
              animation,
              secondaryAnimation,
              child,) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
  }

  Future<void> _loadTmdbPreferences(String userId) async {
    final repository = ProfileRepositoryImpl();
    final getProfile = GetProfile(repository);

    final profile = await getProfile(userId);

    TmdbPreferences.instance.update(
      language: TmdbSettings.getLanguageCode(profile.language),
      country: TmdbSettings.getCountryCode(profile.country),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 75,
              height: 75,
            ),

            const SizedBox(height: 12),

            const Text(
              'CINEMAX',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}