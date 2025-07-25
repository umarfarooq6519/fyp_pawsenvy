import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/theme/theme.dart';

class ProfileMedium extends StatelessWidget {
  final Map<String, dynamic> profile;
  const ProfileMedium({
    super.key,
    required this.profile,
  });
  @override
  Widget build(BuildContext context) {
    final String name = profile['name'] ?? '';
    final String? image = profile['image'] as String?;
    final String? type = profile['type'] as String?;
    final String? about = profile['about'] as String?;
    final String? tag1 = profile['tag1'] as String?;
    final String? tag2 = profile['tag2'] as String?;

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
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [                Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: image != null ? NetworkImage(image) : null,
                    backgroundColor: AppColorStyles.transparent,
                    child: image == null ? Icon(Icons.person, size: 80, color: Colors.grey) : null,
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: AppTextStyles.headingMedium),
                        if (type != null)
                          Text(
                            type,
                            style: AppTextStyles.bodyBase.copyWith(
                              color: AppColorStyles.deepPurple,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                if (tag1 != null || tag2 != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (tag1 != null) ...[
                          Icon(
                            tag1.toLowerCase() == 'male'
                                ? LineIcons.mars
                                : tag1.toLowerCase() == 'female'
                                ? LineIcons.venus
                                : LineIcons.tag,
                            color:
                                tag1.toLowerCase() == 'male'
                                    ? Colors.blue
                                    : tag1.toLowerCase() == 'female'
                                    ? Colors.pink
                                    : AppColorStyles.deepPurple,
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(tag1, style: AppTextStyles.bodySmall),
                          SizedBox(width: 10),
                        ],
                        if (tag2 != null) ...[
                          Icon(
                            Icons.location_on,
                            color: AppColorStyles.deepPurple,
                            size: 18,
                          ),
                          SizedBox(width: 2),
                          Text(tag2, style: AppTextStyles.bodySmall),
                        ],
                      ],
                    ),
                  ),
                if (about != null)
                  Text(
                    about,
                    style: AppTextStyles.bodySmall,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          // ...existing code...
        ],
      ),
    );
  }
}
