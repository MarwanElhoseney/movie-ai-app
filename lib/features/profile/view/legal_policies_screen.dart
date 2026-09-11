import 'package:flutter/material.dart';

class LegalPoliciesScreen extends StatelessWidget {
  const LegalPoliciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _InfoScreen(
      title: 'Legal and Policies',
      content: '''
Terms

Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
Please read these terms carefully before using CinemaX.

Privacy Policy

Your privacy is important to us. We collect and use your 
information only to provide and improve our services.

Changes to the Service

CinemaX may update these terms and policies from time to time.
''',
    );
  }
}

class _InfoScreen extends StatelessWidget {
  final String title;
  final String content;

  const _InfoScreen({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1D2B),
        elevation: 0,
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Text(
          content,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 9,
            height: 1.7,
          ),
        ),
      ),
    );
  }
}
