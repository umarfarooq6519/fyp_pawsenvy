import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fyp_pawsenvy/core/utils/colors.dart';
import 'package:fyp_pawsenvy/core/utils/text_styles.dart';

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
        border: Border.all(color: AppColors.deepPurpleBorder),
        gradient: AppColors.profileGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 10)],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage(
                      image ?? 'assets/images/placeholder.png',
                    ),
                    backgroundColor: AppColors.transparent,
                  ),
                ),
                const SizedBox(height: 24),
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
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              type!,
                              style: AppTextStyles.headingSmall.copyWith(
                                color: AppColors.deepPurple,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (verified)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          LineIcons.checkCircle,
                          color: AppColors.deepPurple,
                          size: 26,
                        ),
                      ),
                  ],
                ),
                if ((tag1 != null && tag1!.isNotEmpty) ||
                    (tag2 != null && tag2!.isNotEmpty))
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 2.0),
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
                                    ? AppColors.male
                                    : tag1!.toLowerCase() == 'female'
                                    ? AppColors.female
                                    : AppColors.deepPurple,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(tag1!, style: AppTextStyles.bodySmall),
                        ],
                        if (tag1 != null &&
                            tag1!.isNotEmpty &&
                            tag2 != null &&
                            tag2!.isNotEmpty)
                          const SizedBox(width: 18),
                        if (tag2 != null && tag2!.isNotEmpty) ...[
                          Icon(
                            Icons.location_on,
                            color: AppColors.deepPurple,
                            size: 20,
                          ),
                          const SizedBox(width: 2),
                          Text(tag2!, style: AppTextStyles.bodySmall),
                        ],
                      ],
                    ),
                  ),
                if (about != null && about!.isNotEmpty) ...[
                  const SizedBox(height: 18),
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
            top: 10,
            right: 10,
            child: Material(
              color: AppColors.transparent,
              child: IconButton(
                onPressed: onFavorite,
                icon: Icon(
                  isFavorite ? LineIcons.heartAlt : LineIcons.heart,
                  color: AppColors.actionRed,
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
