import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fyp_pawsenvy/core/theme/colors.dart';
import 'package:fyp_pawsenvy/core/theme/text_styles.dart';
import 'package:fyp_pawsenvy/core/theme/app_theme.dart';

class ProfileSmall extends StatelessWidget {
  final String name;
  final String? image;
  final String? tag1;
  final String? tag2;
  final VoidCallback? onFavorite;
  final VoidCallback? onTap;

  const ProfileSmall({
    super.key,
    required this.name,
    this.image,
    this.tag1,
    this.tag2,
    this.onFavorite,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: AppColorStyles.lightPurple),
        gradient: AppColorStyles.profileGradient,
        borderRadius: BorderRadius.circular(AppBorderRadius.xLarge),
        boxShadow: [
          BoxShadow(color: AppColorStyles.lightPurple, blurRadius: 7),
        ],
      ),
      margin: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ), // was profileSmallMargin
      child: Stack(
        children: [
          // Card body with tap using InkWell for full coverage
          Material(
            color: AppColorStyles.transparent,
            borderRadius: BorderRadius.circular(28),
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 0),
                    SizedBox(
                      height: 90,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            image ?? 'assets/images/placeholder.png',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColorStyles.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColorStyles.lightPurple),
                      ),
                      child: Text(
                        name,
                        style: AppTextStyles.bodyBase.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      tag1 != null && tag2 != null && tag2!.isNotEmpty
                          ? '$tag1 - $tag2'
                          : tag1 ?? '',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColorStyles.lightGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (onFavorite != null)
            Positioned(
              top: 10,
              right: 10,
              child: Material(
                color: AppColorStyles.transparent,
                child: IconButton(
                  onPressed: onFavorite,
                  icon: Icon(
                    LineIcons.heart,
                    color: AppColorStyles.red,
                    size: 22,
                  ),
                  splashRadius: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
