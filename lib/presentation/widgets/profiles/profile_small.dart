import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fyp_pawsenvy/core/utils/colors.dart';
import 'package:fyp_pawsenvy/core/utils/text_styles.dart';

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
        border: Border.all(color: AppColors.deepPurpleBorder),
        gradient: AppColors.profileGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 7)],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Stack(
        children: [
          // Card body with tap using InkWell for full coverage
          Material(
            color: AppColors.transparent,
            borderRadius: BorderRadius.circular(28),
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
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
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
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
                        color: AppColors.lightGrey,
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
                color: AppColors.transparent,
                child: IconButton(
                  onPressed: onFavorite,
                  icon: Icon(
                    LineIcons.heart,
                    color: AppColors.actionRed,
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
