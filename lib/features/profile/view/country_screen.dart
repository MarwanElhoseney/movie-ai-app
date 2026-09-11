import 'package:flutter/material.dart';

import '../../../core/constants/tmdb_settings.dart';
import '../../../core/network/tmdb_preferences.dart';
import '../domain/entities/profile.dart';
import '../domain/usecases/update_profile_setting.dart';

class CountryScreen extends StatelessWidget {
  final Profile profile;
  final UpdateProfileSetting updateSetting;

  const CountryScreen({
    super.key,
    required this.profile,
    required this.updateSetting,
  });

  static const countries = [
    'Egypt',
    'United Kingdom',
    'United States',
    'Canada',
    'Germany',
    'France',
    'Saudi Arabia',
    'United Arab Emirates',
  ];

  Future<void> _select(BuildContext context, String country) async {
    await updateSetting(userId: profile.id, country: country);

    final countryCode = TmdbSettings.getCountryCode(country);

    TmdbPreferences.instance.update(country: countryCode);

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
          'Country',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: countries.map((country) {
          final selected = profile.country == country;

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 5),
            title: Text(
              country,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            trailing: selected
                ? const Icon(Icons.check, color: Color(0xFF00D5E6), size: 16)
                : null,
            onTap: () => _select(context, country),
          );
        }).toList(),
      ),
    );
  }
}
