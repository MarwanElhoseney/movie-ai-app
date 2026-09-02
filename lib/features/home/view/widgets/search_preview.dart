import 'package:flutter/material.dart';

class SearchPreview extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onFilterTap;

  const SearchPreview({
    super.key,
    required this.onTap,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        color: const Color(0xFF292736),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Colors.white38, size: 17),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: const Text(
                'Search a title...',
                style: TextStyle(color: Colors.white38, fontSize: 9),
              ),
            ),
          ),
          GestureDetector(
            onTap: onFilterTap,
            child: const Icon(
              Icons.tune_rounded,
              color: Colors.white54,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }
}
