import 'package:flutter/material.dart';

import '../../../core/constants/tmdb_settings.dart';
import '../../../core/network/tmdb_preferences.dart';
import '../domain/entities/profile.dart';
import '../domain/usecases/update_profile_setting.dart';

class LanguageScreen extends StatelessWidget {
  final Profile profile;
  final UpdateProfileSetting updateSetting;

  const LanguageScreen({
    super.key,
    required this.profile,
    required this.updateSetting,
  });

  static const languages = [
    'English (UK)',
    'English',
    'Bahasa Indonesia',
    'Chinese',
    'Croatian',
    'Czech',
    'Danish',
    'Filipino',
    'Finnish',
  ];

  Future<void> _select(BuildContext context, String language) async {
    await updateSetting(userId: profile.id, language: language);

    final languageCode = TmdbSettings.getLanguageCode(language);

    TmdbPreferences.instance.update(language: languageCode);

    if (!context.mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1D2B),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Language',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Suggested Languages',
            style: TextStyle(color: Colors.white38, fontSize: 9),
          ),

          const SizedBox(height: 10),

          ...languages.map(
            (language) => _LanguageItem(
              title: language,
              selected: profile.language == language,
              onTap: () => _select(context, language),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageItem extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageItem({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white.withOpacity(.04)),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
            if (selected)
              const Icon(Icons.check, color: Color(0xFF00D5E6), size: 15),
          ],
        ),
      ),
    );
  }
}
