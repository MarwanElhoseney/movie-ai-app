import 'package:flutter/material.dart';

import '../domain/entities/profile.dart';
import '../domain/usecases/update_profile_setting.dart';

class NotificationScreen extends StatefulWidget {
  final Profile profile;
  final UpdateProfileSetting updateSetting;

  const NotificationScreen({
    super.key,
    required this.profile,
    required this.updateSetting,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late bool _enabled;

  @override
  void initState() {
    super.initState();

    _enabled = widget.profile.notificationsEnabled;
  }

  Future<void> _change(bool value) async {
    setState(() {
      _enabled = value;
    });

    await widget.updateSetting(
      userId: widget.profile.id,
      notificationsEnabled: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsScaffold(
      title: 'Notification',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF242230),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Show Notifications',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
            Switch(
              value: _enabled,
              onChanged: _change,
              activeColor: const Color(0xFF00D5E6),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsScaffold extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsScaffold({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1D2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1D2B),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}
