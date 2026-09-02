import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final String text;

  const Info({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white54, fontSize: 8),
    );
  }
}
