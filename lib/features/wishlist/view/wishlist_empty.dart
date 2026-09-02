import 'package:flutter/material.dart';

class WishlistEmpty extends StatelessWidget {
  const WishlistEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/images/wishlist.png', width: 75, height: 75),
        const SizedBox(height: 13),
        const Text(
          'There Is No Movie Yet!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        const Text(
          'Find your movie by title,\ncategories, years, etc.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white38, fontSize: 8),
        ),
      ],
    );
  }
}
