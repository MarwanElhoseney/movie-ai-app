import 'package:flutter/material.dart';

import '../../auth/view/auth_screen.dart';
import '../data/onboarding_data.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  void _nextPage() {
    final bool isLastPage = _currentIndex == OnboardingData.pages.length - 1;

    if (isLastPage) {
      _finishOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  void _finishOnboarding() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,

        itemCount: OnboardingData.pages.length,

        physics: const NeverScrollableScrollPhysics(),

        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        itemBuilder: (context, index) {
          return OnboardingPage(
            data: OnboardingData.pages[index],
            currentIndex: _currentIndex,
            totalPages: OnboardingData.pages.length,
            onNext: _nextPage,
          );
        },
      ),
    );
  }
}
