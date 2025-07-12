import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fyp_pawsenvy/core/theme/colors.dart';
import 'package:fyp_pawsenvy/core/theme/text_styles.dart';
import 'package:fyp_pawsenvy/core/theme/app_theme.dart';

class ProfileMedium extends StatelessWidget {
  final String name;
  final String? image;
  final String? type;
  final String? about;
  final bool verified;
  final bool isFavorite;
  final VoidCallback? onFavorite;
  final VoidCallback? onTap;
  final String? tag1;
  final String? tag2;

  const ProfileMedium({
    super.key,
    required this.name,
    this.image,
    this.type,
    this.about,
    this.verified = false,
    this.isFavorite = false,
    this.onFavorite,
    this.onTap,
    this.tag1,
    this.tag2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
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
      ), // was profileMediumMargin
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.xl,
              AppSpacing.xl,
            ), // was xxl for top
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage(
                      image ?? 'assets/images/placeholder.png',
                    ),
                    backgroundColor: AppColorStyles.transparent,
                  ),
                ),
                SizedBox(height: AppSpacing.xl), // was xxl
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: AppTextStyles.headingMedium),
                        if (type != null && type!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              type!,
                              style: AppTextStyles.headingSmall.copyWith(
                                color: AppColorStyles.deepPurple,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (verified)
                      Padding(
                        padding: EdgeInsets.only(left: AppSpacing.sm),
                        child: Icon(
                          LineIcons.checkCircle,
                          color: AppColorStyles.deepPurple,
                          size: 26,
                        ),
                      ),
                  ],
                ),
                if ((tag1 != null && tag1!.isNotEmpty) ||
                    (tag2 != null && tag2!.isNotEmpty))
                  Padding(
                    padding: EdgeInsets.only(
                      top: AppSpacing.sm + AppSpacing.xs,
                      bottom: AppSpacing.xs,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (tag1 != null && tag1!.isNotEmpty) ...[
                          Icon(
                            tag1!.toLowerCase() == 'male'
                                ? LineIcons.mars
                                : tag1!.toLowerCase() == 'female'
                                ? LineIcons.venus
                                : LineIcons.tag,
                            color:
                                tag1!.toLowerCase() == 'male'
                                    ? Colors.blue
                                    : tag1!.toLowerCase() == 'female'
                                    ? Colors.pink
                                    : AppColorStyles.deepPurple,
                            size: 20,
                          ),
                          SizedBox(width: AppSpacing.xs + AppSpacing.xs),
                          Text(tag1!, style: AppTextStyles.bodySmall),
                        ],
                        if (tag1 != null &&
                            tag1!.isNotEmpty &&
                            tag2 != null &&
                            tag2!.isNotEmpty)
                          SizedBox(width: AppSpacing.lg + AppSpacing.xs),
                        if (tag2 != null && tag2!.isNotEmpty) ...[
                          Icon(
                            Icons.location_on,
                            color: AppColorStyles.deepPurple,
                            size: 20,
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Text(tag2!, style: AppTextStyles.bodySmall),
                        ],
                      ],
                    ),
                  ),
                if (about != null && about!.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.lg + AppSpacing.xs),
                  Text(
                    about!,
                    style: AppTextStyles.bodyBase,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            top: AppSpacing.sm + AppSpacing.xs,
            right: AppSpacing.sm + AppSpacing.xs,
            child: Material(
              color: AppColorStyles.transparent,
              child: IconButton(
                onPressed: onFavorite,
                icon: Icon(
                  isFavorite ? LineIcons.heartAlt : LineIcons.heart,
                  color: AppColorStyles.red,
                  size: 28,
                ),
                splashRadius: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
