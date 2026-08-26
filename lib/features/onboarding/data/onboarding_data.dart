import '../model/onboarding_model.dart';

class OnboardingData {
  static const List<OnboardingModel> pages = [
    OnboardingModel(
      image: 'assets/images/onboarding.png',
      title: 'Discover Amazing Movies',
      description:
          'Explore thousands of movies and find your next favorite one.',
    ),
    OnboardingModel(
      image: 'assets/images/Onboarding (1).png',
      title: 'Find Your Favorite',
      description:
          'Browse through different categories and discover great movies.',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding (2).png',
      title: 'Enjoy Your Movies',
      description:
          'Sit back, grab your popcorn and enjoy your favorite movies.',
    ),
  ];
}
