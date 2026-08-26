import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onTap;

  const NextButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        height: 55,

        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),

        child: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 19,
          color: AppColors.background,
        ),
      ),
    );
  }
}
