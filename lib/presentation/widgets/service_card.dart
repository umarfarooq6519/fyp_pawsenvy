import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import '../../core/theme/text.styles.dart';
import '../../core/theme/theme.dart';

class ServiceCard extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.image,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppBorderRadius.large),
                border: Border.all(color: AppColorStyles.lightPurple, width: 2),
                boxShadow: AppShadows.lightShadow,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  AppBorderRadius.large,
                ), // was serviceCardRadius
                child: Image.asset(image, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              label,
              style: AppTextStyles.bodyBase.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
