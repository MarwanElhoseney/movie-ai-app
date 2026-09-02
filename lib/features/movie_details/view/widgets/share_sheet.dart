import 'package:flutter/material.dart';

import 'social.dart';

class ShareSheet extends StatelessWidget {
  const ShareSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF292736),
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Spacer(),

              const Text(
                'Share to',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white54,
                  size: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Social(icon: Icons.facebook, color: Color(0xFF4267B2)),
              Social(icon: Icons.camera_alt, color: Color(0xFFE1306C)),
              Social(icon: Icons.messenger, color: Color(0xFF2196F3)),
              Social(icon: Icons.send, color: Color(0xFF00A8E8)),
            ],
          ),
        ],
      ),
    );
  }
}
