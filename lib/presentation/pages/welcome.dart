import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/router/routes.dart';
import 'package:fyp_pawsenvy/core/utils/colors.dart';
import 'package:fyp_pawsenvy/core/utils/text_styles.dart';
import 'package:fyp_pawsenvy/core/theme/app_theme.dart';
import 'package:fyp_pawsenvy/presentation/widgets/common/app_button.dart';
import 'package:go_router/go_router.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: Column(
          children: [
            // Image container with bottom rounded corners only
            Container(
              width: double.infinity,
              height: 420,
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
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback container if image doesn't exist
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppBorderRadius.xLarge,
                        ).copyWith(
                          // was cardRadius
                          topLeft: Radius.zero,
                          topRight: Radius.zero,
                        ),
                        color: Colors.orange.shade300,
                      ),
                      child: const Center(
                        child: Icon(Icons.pets, size: 80, color: Colors.white),
                      ),
                    );
                  },
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
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Connect with pet lovers, find care services, and manage your pet\'s needs all in one place. Join our community today!',
                    style: AppTextStyles.bodyBase.copyWith(
                      color: AppColors.grey,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Spacer(), // Google Sign In Button
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
              ), // was paddingHorizontalXXL
              width: double.infinity,
              height: 56,
              margin: EdgeInsets.only(bottom: AppSpacing.huge),
              child: GoogleSignInButton(
                onPressed: () {
                  context.go(Routes.petOwner);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
