import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/utils/colors.dart';
import 'package:fyp_pawsenvy/core/utils/text_styles.dart';

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
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.deepPurpleBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.transparent,
            backgroundImage: avatar != null ? AssetImage(avatar!) : null,
            child:
                avatar == null
                    ? const Icon(Icons.pets, color: Color(0xFFBDB8E2), size: 28)
                    : null,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.headingSmall),
                if (subtitle != null) ...[
                  const SizedBox(height: 0),
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodyBase.copyWith(
                      color: AppColors.black.withOpacity(0.6),
                    ),
                  ),
                ],
                if (tags != null && tags!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(tags!.join(' | '), style: AppTextStyles.bodySmall),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
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
