import 'package:flutter/material.dart';
import 'package:movie_app/core/navigation/main_shell/view/widgets/main_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../../../features/auth/domain/entities/user.dart' as app_user;
import '../../../../features/home/view/home_screen.dart';
import '../../../../features/profile/view/profile_screen.dart';
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

  late app_user.User _currentUser;

  @override
  void initState() {
    super.initState();

    _currentUser = widget.user;
  }

  void _updateUser(app_user.User updatedUser) {
    setState(() {
      _currentUser = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),

      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            user: _currentUser,
            onProfileTap: () {
              setState(() {
                _currentIndex = 3;
              });
            },
          ),

          SearchScreen(
            user: _currentUser,
          ),

          const WishlistScreen(),

          ProfileScreen(
            user: _currentUser,
            onUserUpdated: _updateUser,
          ),
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