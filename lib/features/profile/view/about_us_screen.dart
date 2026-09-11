import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1D2B),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', width: 65, height: 65),
            const SizedBox(height: 12),
            const Text(
              'CINEMAX',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your favorite movies, all in one place.',
              style: TextStyle(color: Colors.white54, fontSize: 9),
            ),
            const SizedBox(height: 15),
            const Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.white30, fontSize: 8),
            ),
          ],
        ),
      ),
    );
  }
}
