import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onCancel;
  final VoidCallback? onFilterTap;
  final IconData? suffixIcon;
  final String hint;

  const SearchInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.onCancel,
    this.onFilterTap,
    this.suffixIcon,
    this.hint = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF292736),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(color: Colors.white, fontSize: 10),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.white38,
                  size: 17,
                ),
                suffixIcon: onFilterTap == null
                    ? null
                    : IconButton(
                        onPressed: onFilterTap,
                        icon: Icon(
                          suffixIcon,
                          color: const Color(0xFF00D5E6),
                          size: 17,
                        ),
                      ),
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 8),
                border: InputBorder.none,
              ),
            ),
          ),
        ),

        if (onCancel != null) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onCancel,
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70, fontSize: 8),
            ),
          ),
        ],
      ],
    );
  }
}
