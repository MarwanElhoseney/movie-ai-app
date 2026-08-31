import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../home/view/home_screen.dart';
import '../domain/repositories/auth_repository_impl.dart';
import '../domain/usecases/sign_in_with_google.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isGoogleLoading = false;

  Future<void> _signInWithGoogle() async {
    if (_isGoogleLoading) {
      return;
    }

    setState(() {
      _isGoogleLoading = true;
    });

    try {
      final repository = AuthRepositoryImpl();

      final signInWithGoogle = SignInWithGoogle(repository);

      await signInWithGoogle();

      if (!mounted) return;


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      await _showMessageDialog(
        title: 'Google Sign In Failed',
        message: _getFirebaseErrorMessage(e),
      );
    } catch (e) {
      if (!mounted) return;

      await _showMessageDialog(
        title: 'Something Went Wrong',
        message: 'Unable to sign in with Google. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  Future<void> _showMessageDialog({
    required String title,
    required String message,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'network-request-failed':
        return 'Please check your internet connection.';

      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';

      case 'invalid-credential':
        return 'The Google credential is invalid. Please try again.';

      case 'google-sign-in-cancelled':
        return 'Google sign in was cancelled.';

      default:
        return e.message ?? 'Unable to sign in with Google.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              const Spacer(flex: 2),

              Image.asset(
                "assets/images/logo.png",
                width: 60,
                height: 60,
              ),

              const SizedBox(height: 12),

              const Text(
                'CINEMAX',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 7),

              const Text(
                'Enter your registered',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'Phone Number to Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),

              const Spacer(),

              AppButton(
                title: 'Sign Up',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignUpScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 9,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              const Text(
                'Or Sign in with',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 9,
                ),
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialButton(
                    color: Colors.white,
                    isLoading: _isGoogleLoading,
                    onTap: _signInWithGoogle,
                    child: const Text(
                      'G',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 25),

                  _SocialButton(
                    color: Colors.blue,
                    child: const Icon(
                      Icons.facebook,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget child;
  final Color? color;
  final VoidCallback? onTap;
  final bool isLoading;

  const _SocialButton({
    required this.child,
    this.color,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.black,
            ),
          )
              : child,
        ),
      ),
    );
  }
}