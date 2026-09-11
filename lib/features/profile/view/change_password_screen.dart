import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _oldPasswordController = TextEditingController();

  final _newPasswordController = TextEditingController();

  final _confirmPasswordController = TextEditingController();

  bool _oldVisible = false;
  bool _newVisible = false;
  bool _confirmVisible = false;
  bool _loading = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _oldPasswordController.text,
      );

      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(_newPasswordController.text);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message;

      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Current password is incorrect.';
          break;

        case 'weak-password':
          message = 'New password is too weak.';
          break;

        case 'requires-recent-login':
          message = 'Please log in again before changing your password.';
          break;

        default:
          message = e.message ?? 'Unable to change password.';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                const Text(
                  'Change Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 35),

                AppTextField(
                  controller: _oldPasswordController,
                  label: 'Current Password',
                  hint: '••••••••',
                  obscureText: !_oldVisible,
                  validator: _passwordValidator,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _oldVisible = !_oldVisible;
                      });
                    },
                    icon: Icon(
                      _oldVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                AppTextField(
                  controller: _newPasswordController,
                  label: 'New Password',
                  hint: '••••••••',
                  obscureText: !_newVisible,
                  validator: _passwordValidator,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _newVisible = !_newVisible;
                      });
                    },
                    icon: Icon(
                      _newVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                AppTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  hint: '••••••••',
                  obscureText: !_confirmVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm your password';
                    }

                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }

                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _confirmVisible = !_confirmVisible;
                      });
                    },
                    icon: Icon(
                      _confirmVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                AppButton(
                  title: 'Save Changes',
                  onPressed: _changePassword,
                  isLoading: _loading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
