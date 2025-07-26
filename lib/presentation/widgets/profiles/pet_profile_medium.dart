import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/pet.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/theme/theme.dart';

class PetProfileMedium extends StatelessWidget {
  final Pet pet;
  const PetProfileMedium({super.key, required this.pet});
  @override
  Widget build(BuildContext context) {
    final String name = pet.name;
    final String species = pet.species.name;
    final String about = pet.bio;
    final String gender = pet.gender;
    final String breed = pet.breed;

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
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage(
                      species == 'dog'
                          ? 'assets/images/dog.png'
                          : 'assets/images/cat.png',
                    ),
                    backgroundColor: AppColorStyles.lightPurple,
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
                        Row(
                          children: [
                            Icon(
                              species == 'dog' ? LineIcons.dog : LineIcons.cat,
                              color: AppColorStyles.deepPurple,
                            ),
                            SizedBox(width: 2),
                            Text(
                              species,
                              style: AppTextStyles.bodyBase.copyWith(
                                color: AppColorStyles.deepPurple,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        gender.toLowerCase() == 'male'
                            ? LineIcons.mars
                            : gender.toLowerCase() == 'female'
                            ? LineIcons.venus
                            : LineIcons.tag,
                        color:
                            gender.toLowerCase() == 'male'
                                ? Colors.blue
                                : gender.toLowerCase() == 'female'
                                ? Colors.pink
                                : AppColorStyles.deepPurple,
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(gender, style: AppTextStyles.bodySmall),
                      SizedBox(width: 10),
                      Icon(
                        LineIcons.paw,
                        color: AppColorStyles.deepPurple,
                        size: 18,
                      ),
                      SizedBox(width: 2),
                      Text(breed, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
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
