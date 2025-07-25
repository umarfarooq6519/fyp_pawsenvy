import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/services/auth.service.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/theme/theme.dart';
import 'package:fyp_pawsenvy/core/router/routes.dart';
import 'package:fyp_pawsenvy/providers/user.provider.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AppUser? appUser = context.watch<UserProvider>().user;
    // ignore: no_leading_underscores_for_local_identifiers
    final AuthService _auth = Provider.of<AuthService>(context, listen: false);

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
                        appUser?.avatar != null
                            ? NetworkImage(appUser!.avatar)
                            : const AssetImage('assets/images/person1.png'),
                    backgroundColor: AppColorStyles.lightGrey,
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    appUser?.name ?? "Guest",
                    style: AppTextStyles.headingSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColorStyles.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Email
                  Text(
                    appUser?.email ?? 'no email found',
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
                    onTap:
                        () => _navigateToUserProfile(
                          context,
                          _auth.currentUser!.uid,
                        ),
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
              child: _signOutButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToUserProfile(BuildContext context, String uID) async {
    try {
      if (context.mounted) {
        context.push(Routes.userProfile, extra: uID);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading profile: $e')));
      }
    }
  }

  ElevatedButton _signOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _handleSignOut(context),
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

  void _handleSignOut(BuildContext context) async {
    try {
      await AuthService().signOut();
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Use Signed Out')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
      }
    }
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
      ),
    );
  }
}
