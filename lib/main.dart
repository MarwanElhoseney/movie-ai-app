import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const CinemaXApp());
}

class CinemaXApp extends StatelessWidget {
  const CinemaXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'CinemaX',

      theme: AppTheme.theme,

      home: const SplashScreen(),
    );
  }
}
