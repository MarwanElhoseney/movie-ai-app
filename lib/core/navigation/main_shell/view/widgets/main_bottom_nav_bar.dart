import 'package:flutter/material.dart';

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MainBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF242230),
      selectedItemColor: const Color(0xFF00D5E6),
      unselectedItemColor: Colors.white38,
      selectedFontSize: 8,
      unselectedFontSize: 8,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined, size: 18),
          activeIcon: Icon(Icons.home_rounded, size: 18),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined, size: 18),
          activeIcon: Icon(Icons.search_rounded, size: 18),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border_rounded, size: 18),
          activeIcon: Icon(Icons.favorite_rounded, size: 18),
          label: 'Wishlist',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_rounded, size: 18),
          activeIcon: Icon(Icons.person_rounded, size: 18),
          label: 'Profile',
        ),
      ],
    );
  }
}
