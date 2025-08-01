import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/pet.dart';
import 'package:fyp_pawsenvy/core/utils/text.util.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:fyp_pawsenvy/providers/user.provider.dart';

class PetProfileMedium extends StatelessWidget {
  final Pet pet;

  const PetProfileMedium({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final String name = pet.name;
    final String species = pet.species.name;
    final String bio = pet.bio;
    final String gender = pet.gender;
    final String breed = pet.breed;
    final PetStatus status = pet.status;

    final userProvider = Provider.of<UserProvider>(context);
    final bool isOwnedByUser =
        userProvider.user?.ownedPets.contains(pet.pID) ?? false;

    final BoxShadow shadow = BoxShadow(
      color: AppColorStyles.lightPurple,
      blurRadius: isOwnedByUser ? 7 : 3,
    );

    return Container(
      width: 260,
      decoration: BoxDecoration(
        border: Border.all(color: AppColorStyles.lightPurple),
        gradient: isOwnedByUser ? AppColorStyles.profileGradient : null,
        color: isOwnedByUser ? null : AppColorStyles.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.xLarge),
        boxShadow: [shadow],
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
                      pet.avatar.isNotEmpty
                          ? pet.avatar
                          : pet.species == PetSpecies.dog
                          ? 'assets/images/dog.png'
                          : pet.species == PetSpecies.cat
                          ? 'assets/images/cat.png'
                          : 'assets/images/placeholder.png',
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
                        Text(
                          capitalizeFirst(name),
                          style: AppTextStyles.headingMedium,
                        ),
                        Text(
                          capitalizeFirst(species),
                          style: AppTextStyles.bodyBase.copyWith(
                            color: AppColorStyles.deepPurple,
                          ),
                        ),
                      ],
                    ),
                    if (status.name != 'normal')
                      Chip(
                        padding: EdgeInsets.all(0),
                        label: Text(
                          capitalizeFirst(status.name),
                          style: AppTextStyles.bodyExtraSmall,
                        ),
                        backgroundColor: AppColorStyles.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                      Text(
                        capitalizeFirst(gender),
                        style: AppTextStyles.bodySmall,
                      ),
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
                  capitalizeFirst(bio),
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
