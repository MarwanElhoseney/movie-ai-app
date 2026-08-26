import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final VoidCallback? onBack;

  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onBack ?? () => Navigator.pop(context),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),

            const Spacer(),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),

            const Spacer(),

            const SizedBox(width: 30),
          ],
        ),

        const SizedBox(height: 35),

        if (subtitle != null)
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

        if (description != null) ...[
          const SizedBox(height: 6),
          Text(
            description!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}
