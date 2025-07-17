import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/services/auth.service.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/theme/theme.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final User? user = authService.currentUser;

    return Drawer(
      backgroundColor: AppColorStyles.white,
      child: SafeArea(
        child: Column(
          children: [
            // Header section with avatar, name, and email
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Circle Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        user != null
                            ? NetworkImage(user.photoURL!)
                            : const AssetImage('assets/images/person1.png')
                                as ImageProvider,
                    backgroundColor: AppColorStyles.lightGrey,
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    'Umar Farooq',
                    style: AppTextStyles.headingSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColorStyles.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Email
                  Text(
                    'umarfarooq@gmail.com',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColorStyles.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Menu items
            Expanded(
              child: Column(
                children: [
                  _buildDrawerItem(
                    icon: Icons.account_circle_outlined,
                    title: 'My Profile Card',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: LineIcons.cog,
                    title: 'Settings',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.xl),
              child: _signOutButton(context, authService),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton _signOutButton(BuildContext context, AuthService authService) {
    return ElevatedButton(
      onPressed: () async {
        try {
          await authService.signOut();
        } catch (e) {
          print("Error signing out: $e");
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorStyles.pastelRed,
        foregroundColor: AppColorStyles.black,
        elevation: 0,
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.lg,
        ), // was EdgeInsets.symmetric(vertical: 16)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        ),
      ),
      child: Text('Sign out', style: AppTextStyles.bodyBase),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColorStyles.black, size: 24),
      title: Text(
        title,
        style: AppTextStyles.bodyBase.copyWith(
          color: AppColorStyles.black,
          fontWeight: FontWeight.w400,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xs,
      ), // was EdgeInsets.symmetric(horizontal: 24, vertical: 4)
    );
  }
}
