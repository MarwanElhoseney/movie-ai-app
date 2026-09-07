import 'package:flutter/material.dart';

class Social extends StatelessWidget {
  final IconData? icon;
  final String? image;
  final Color color;
  final VoidCallback onTap;

  const Social({
    super.key,
    this.icon,
    this.image,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: image != null
            ? Image.asset(
          image!,
          width: 19,
          height: 19,
        )
            : Icon(
          icon,
          color: Colors.white,
          size: 19,
        ),
      ),
    );
  }
}