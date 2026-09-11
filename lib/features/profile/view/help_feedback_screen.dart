import 'package:flutter/material.dart';

class HelpFeedbackScreen extends StatelessWidget {
  const HelpFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1D2B),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Help & Feedback',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(18),
        child: Text(
          'Need help?\n\n'
          'If you have any questions or feedback '
          'about CinemaX, please contact our support team.',
          style: TextStyle(color: Colors.white60, fontSize: 10, height: 1.7),
        ),
      ),
    );
  }
}
