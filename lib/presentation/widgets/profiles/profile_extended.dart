import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/theme/colors.dart';
import 'package:fyp_pawsenvy/core/theme/text_styles.dart';
import 'package:fyp_pawsenvy/core/theme/app_theme.dart';

class ExtendedCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<String>? tags;
  final String? trailing;
  final String? avatar;
  const ExtendedCard({
    super.key,
    required this.title,
    this.subtitle,
    this.tags,
    this.trailing,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
      ), // was extendedCardMargin
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg + AppSpacing.xs,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColorStyles.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.large),
        border: Border.all(color: AppColorStyles.lightPurple, width: 1),
        boxShadow: AppShadows.lightShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColorStyles.transparent,
            backgroundImage: avatar != null ? AssetImage(avatar!) : null,
            child:
                avatar == null
                    ? const Icon(Icons.pets, color: Color(0xFFBDB8E2), size: 28)
                    : null,
          ),
          SizedBox(width: AppSpacing.xs + AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.headingSmall),
                if (subtitle != null) ...[
                  SizedBox(height: 0),
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodyBase.copyWith(
                      color: AppColorStyles.black.withOpacity(0.6),
                    ),
                  ),
                ],
                if (tags != null && tags!.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.xs),
                  Text(tags!.join(' | '), style: AppTextStyles.bodySmall),
                ],
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          if (trailing != null)
            Align(
              alignment: Alignment.bottomRight,
              child: Text(trailing!, style: AppTextStyles.bodySmall),
            ),
        ],
      ),
    );
  }
}
