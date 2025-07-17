import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/theme/theme.dart';
import 'package:fyp_pawsenvy/core/services/auth.service.dart';
import 'package:provider/provider.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColorStyles.gradientStart, AppColorStyles.gradientEnd],
          ),
        ),
        child: Column(
          children: [
            // Image container with bottom rounded corners only
            Container(
              width: double.infinity,
              height: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  AppBorderRadius.xLarge,
                ).copyWith(
                  // was cardRadius
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                ),
                boxShadow: AppShadows.heavyShadow,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppBorderRadius.xLarge,
                ).copyWith(
                  // was cardRadius
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                ),
                child: Image.asset(
                  'assets/images/welcome.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Spacer(), // Content section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
              ), // was paddingHorizontalXXL
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome to PawsEnvy',
                    style: AppTextStyles.headingLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColorStyles.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Connect with pet lovers, find care services, and manage your pet\'s needs all in one place. Join our community today!',
                    style: AppTextStyles.bodyBase.copyWith(
                      color: AppColorStyles.grey,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              width: double.infinity,
              height: 56,
              margin: EdgeInsets.only(bottom: AppSpacing.huge),
              child: _googleSigninButton(context),
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton _googleSigninButton(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        minimumSize: const Size.fromHeight(56),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.large),
        ),
        elevation: 2,
        shadowColor: Colors.black26,
      ),
      icon: Image.asset('assets/images/google_logo.png', height: 24, width: 24),

      label: Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Text('Sign in with Google', style: AppTextStyles.bodyBase),
      ),
      onPressed: () async {
        try {
          await authService.signInWithGoogle();
        } catch (e) {
          print("Error signing in with Google: $e");
        }
      },
    );
  }
}
