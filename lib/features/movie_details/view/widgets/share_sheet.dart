import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'social.dart';

class ShareSheet extends StatelessWidget {
  final String movieTitle;
  final String movieUrl;

  const ShareSheet({
    super.key,
    required this.movieTitle,
    required this.movieUrl,
  });

  Future<void> _openUrl(BuildContext context,
      Uri uri,) async {
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open the app'),
          ),
        );
      }
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the app'),
        ),
      );
    }
  }

  Future<void> _shareFacebook(BuildContext context) async {
    final uri = Uri.parse(
      'https://www.facebook.com/sharer/sharer.php'
          '?u=${Uri.encodeComponent(movieUrl)}',
    );

    await _openUrl(context, uri);
  }

  Future<void> _shareMessenger(BuildContext context) async {
    final uri = Uri.parse(
      'fb-messenger://share'
          '?link=${Uri.encodeComponent(movieUrl)}',
    );

    await _openUrl(context, uri);
  }

  Future<void> _shareWhatsApp(BuildContext context) async {
    final message = '$movieTitle\n$movieUrl';

    final uri = Uri.parse(
      'whatsapp://send'
          '?text=${Uri.encodeComponent(message)}',
    );

    await _openUrl(context, uri);
  }

  Future<void> _shareTelegram(BuildContext context) async {
    final uri = Uri.parse(
      'https://t.me/share/url'
          '?url=${Uri.encodeComponent(movieUrl)}'
          '&text=${Uri.encodeComponent(movieTitle)}',
    );

    await _openUrl(context, uri);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        30,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF292736),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
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
            children: [
              Social(
                icon: Icons.facebook,
                color: const Color(0xFF4267B2),
                onTap: () => _shareFacebook(context),
              ),

              Social(
                image: ("assets/images/Facebook_Messenger-Logo.wine.png"),
                color: Colors.white,
                onTap: () => _shareMessenger(context),
              ),

              Social(
                image: ("assets/images/WhatsApp-Logo.wine.png"),
                color: const Color(0xFF25D366),
                onTap: () => _shareWhatsApp(context),
              ),

              Social(
                icon: Icons.send,
                color: const Color(0xFF00A8E8),
                onTap: () => _shareTelegram(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}