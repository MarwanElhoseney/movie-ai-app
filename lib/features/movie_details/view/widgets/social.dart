import 'package:flutter/material.dart';

class Social extends StatelessWidget {
  final IconData icon;
  final Color color;

  const Social({super.key, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 19),
    );
  }
}
