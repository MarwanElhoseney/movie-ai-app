import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/validators/app_validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auth_header.dart';
import '../../../core/constants/tmdb_settings.dart';
import '../../../core/navigation/main_shell/view/main_shell.dart';
import '../../../core/network/tmdb_preferences.dart';
import '../../profile/data/repositories/profile_repository_impl.dart';
import '../../profile/domain/usecases/get_profile.dart';
import '../../wishlist/view/wishlist_provider.dart';
import '../domain/repositories/auth_repository_impl.dart';
import '../domain/usecases/login.dart';
import 'reset_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _showMessageDialog({
    required String title,
    required String message,
  }) {
    return showDialog(
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
      case 'invalid-email':
        return 'The email address is invalid.';

      case 'user-not-found':
        return 'No account found with this email address.';

      case 'wrong-password':
        return 'Incorrect password.';

      case 'invalid-credential':
        return 'Incorrect email or password.';

      case 'email-not-verified':
        return 'Please verify your email before logging in.';

      case 'too-many-requests':
        return 'Too many requests. Please try again later.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      default:
        return e.message ?? 'Something went wrong. Please try again.';
    }
  }

  Future<void> _login() async {

    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final repository = AuthRepositoryImpl();

      final login = Login(repository);

      final user = await login.call(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      try {
        final profileRepository = ProfileRepositoryImpl();
        final getProfile = GetProfile(profileRepository);

        final profile = await getProfile(user.id);

        TmdbPreferences.instance.update(
          language: TmdbSettings.getLanguageCode(profile.language),
          country: TmdbSettings.getCountryCode(profile.country),
        );
      } catch (e) {}

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) {
            return ChangeNotifierProvider(
              create: (_) =>
              WishlistProvider(
                userId: user.id,
              )
                ..loadWishlist(),
              child: MainShell(
                user: user,
              ),
            );
          },
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      await _showMessageDialog(
        title: 'Login Failed',
        message: _getFirebaseErrorMessage(e),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      await _showMessageDialog(
        title: 'Something Went Wrong',
        message: 'Please try again later.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                const AuthHeader(
                  title: 'Login',
                  subtitle: 'Hi, Marwan',
                  description:
                      'Welcome back! Please enter your\naccount details.',
                ),

                const SizedBox(height: 38),

                AppTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  hint: 'marwan@example.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidators.email,
                ),

                const SizedBox(height: 18),

                AppTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: '••••••••',
                  obscureText: !_isPasswordVisible,
                  validator: AppValidators.password,

                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ResetPasswordScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xFF00D5E6), fontSize: 10),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                AppButton(
                  title: 'Login',
                  onPressed: _login,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.grey, fontSize: 9),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFF00D5E6),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


