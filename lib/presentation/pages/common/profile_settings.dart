import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/theme/text_styles.dart';
import 'package:fyp_pawsenvy/core/theme/app_theme.dart';
import 'package:line_icons/line_icons.dart';

class ProfileSettings extends StatelessWidget {
  final String name;
  final String email;
  final String avatar;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final VoidCallback onLogout;

  const ProfileSettings({
    super.key,
    required this.name,
    required this.email,
    required this.avatar,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kToolbarHeight - 20,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LineIcons.arrowLeft, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
        ), // was pagePadding
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.huge,
            ), // was EdgeInsets.symmetric(vertical: 40)
            child: Column(
              children: [
                CircleAvatar(radius: 46, backgroundImage: AssetImage(avatar)),
                Center(child: Text(name, style: AppTextStyles.headingMedium)),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    email,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
              // Settings section
            ),
          ),
          SizedBox(height: 18),
          SettingsSection(
            notificationsEnabled: notificationsEnabled,
            onNotificationsChanged: onNotificationsChanged,
            onLogout: onLogout,
          ),
        ],
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final VoidCallback onLogout;

  const SettingsSection({
    super.key,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(LineIcons.bell, color: Colors.black54),
                const SizedBox(width: 12),
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
            Switch(
              value: notificationsEnabled,
              onChanged: onNotificationsChanged,
            ),
          ],
        ),
        const Divider(height: 32),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            LineIcons.alternateSignOut,
            color: Colors.redAccent,
          ),
          title: Text(
            'Logout',
            style: AppTextStyles.bodyBase.copyWith(color: Colors.redAccent),
          ),
          onTap: onLogout,
        ),
      ],
    );
  }
}
