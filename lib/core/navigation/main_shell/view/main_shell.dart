import 'package:flutter/material.dart';
import 'package:movie_app/core/navigation/main_shell/view/widgets/main_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../../../features/auth/domain/entities/user.dart' as app_user;
import '../../../../features/home/view/home_screen.dart';
import '../../../../features/search/view/search_screen.dart';
import '../../../../features/wishlist/view/wishlist_provider.dart';
import '../../../../features/wishlist/view/wishlist_screen.dart';

class MainShell extends StatelessWidget {
  final app_user.User user;

  const MainShell({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
      WishlistProvider(
        userId: user.id,
      )
        ..loadWishlist(),
      child: _MainShellView(
        user: user,
      ),
    );
  }
}

class _MainShellView extends StatefulWidget {
  final app_user.User user;

  const _MainShellView({
    required this.user,
  });

  @override
  State<_MainShellView> createState() => _MainShellViewState();
}

class _MainShellViewState extends State<_MainShellView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            user: widget.user,
          ),
          SearchScreen(
            user: widget.user,
          ),
          const WishlistScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profile',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }
}