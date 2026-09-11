import 'package:flutter/material.dart';

import '../../../core/validators/app_validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/auth_header.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../domain/entities/profile.dart';
import '../domain/usecases/update_profile.dart';

class EditProfileScreen extends StatefulWidget {
  final Profile profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  late final ProfileRepositoryImpl _repository;
  late final UpdateProfile _updateProfile;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _repository = ProfileRepositoryImpl();

    _updateProfile = UpdateProfile(_repository);

    _nameController = TextEditingController(text: widget.profile.name);

    _emailController = TextEditingController(text: widget.profile.email);

    _phoneController = TextEditingController(text: widget.profile.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final newName = _nameController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final isNameTaken = await _repository.isNameTaken(
        name: newName,
        currentUserId: widget.profile.id,
      );

      if (isNameTaken) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'This name is already in use. Please choose another name.',
            ),
          ),
        );

        return;
      }

      await _updateProfile(
        userId: widget.profile.id,
        name: newName,

        // الإيميل يفضل زي ما هو
        email: widget.profile.email,

        phoneNumber: _phoneController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pop(
        context,
        Profile(
          id: widget.profile.id,
          name: newName,
          email: widget.profile.email,
          phoneNumber: _phoneController.text.trim(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Unable to update profile')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

                const AuthHeader(
                  title: 'Edit Profile',
                  subtitle: 'Edit Profile',
                  description: 'Update your personal information.',
                ),

                const SizedBox(height: 28),

                CircleAvatar(
                  radius: 34,
                  backgroundColor: const Color(0xFF373545),
                  child: Text(
                    widget.profile.name.isEmpty
                        ? '?'
                        : widget.profile.name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),

                const SizedBox(height: 28),

                // =========================
                // Name
                // =========================
                AppTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Marwan',
                  validator: (value) {
                    return AppValidators.required(value, 'Full name');
                  },
                ),

                const SizedBox(height: 15),

                // =========================
                // Email - READ ONLY
                // =========================
                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'marwan@example.com',
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true,
                  validator: AppValidators.email,
                ),

                const SizedBox(height: 15),

                // =========================
                // Phone
                // =========================
                AppTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: '+20 100 000 0000',
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 25),

                AppButton(
                  title: 'Save Changes',
                  onPressed: _save,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
