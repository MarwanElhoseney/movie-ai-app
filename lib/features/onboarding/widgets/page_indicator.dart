import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int length;

  const PageIndicator({
    super.key,
    required this.currentIndex,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(length, (index) {
        final bool isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,

          margin: const EdgeInsets.only(right: 7),

          width: isActive ? 28 : 7,
          height: 7,

          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.indicatorInactive,

            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}
