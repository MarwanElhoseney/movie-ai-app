import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../model/onboarding_model.dart';
import 'next_button.dart';
import 'page_indicator.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel data;
  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;

  const OnboardingPage({
    super.key,
    required this.data,
    required this.currentIndex,
    required this.totalPages,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.025),

          /// IMAGE
          Expanded(
            flex: 55,
            child: Center(
              child: Image.asset(
                data.image,
                fit: BoxFit.contain,
                width: size.width * 0.88,
              ),
            ),
          ),

          /// CONTENT
          Expanded(
            flex: 28,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 19,
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),

                const SizedBox(height: 13),

                Text(
                  data.description,
                  textAlign: TextAlign.center,
                  maxLines: 4,
                  style: const TextStyle(
                    fontSize: 11.5,
                    height: 1.55,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          /// BOTTOM
          Expanded(
            flex: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PageIndicator(currentIndex: currentIndex, length: totalPages),

                NextButton(onTap: onNext),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
