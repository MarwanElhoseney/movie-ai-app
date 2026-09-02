import 'package:flutter/material.dart';

import '../../../auth/domain/entities/user.dart';

class HomeHeader extends StatelessWidget {
  final User user;
  final VoidCallback? onProfileTap;
  final VoidCallback? onWishlistTap;

  const HomeHeader({
    super.key,
    required this.user,
    this.onProfileTap,
    this.onWishlistTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onProfileTap,
          child: const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF3B394A),
            child: Icon(Icons.person, color: Colors.white70, size: 20),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${user.name}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "Let's stream your favorite movie",
                style: TextStyle(color: Colors.white54, fontSize: 8),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onWishlistTap,
          icon: const Icon(Icons.favorite, color: Color(0xFFFF5368), size: 20),
        ),
      ],
    );
  }
}
