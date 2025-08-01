import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/theme/theme.dart';
import 'package:fyp_pawsenvy/core/models/pet.dart';
import 'package:fyp_pawsenvy/core/utils/text.util.dart';
import 'package:provider/provider.dart';
import 'package:fyp_pawsenvy/providers/user.provider.dart';

class PetProfileExtended extends StatelessWidget {
  final Pet pet;

  const PetProfileExtended({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isOwned = userProvider.user?.ownedPets.contains(pet.pID) ?? false;

    final BoxShadow shadow = BoxShadow(
      color: AppColorStyles.lightPurple,
      blurRadius: isOwned ? 7 : 3,
    );

    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: AppColorStyles.lightPurple),
        gradient: isOwned ? AppColorStyles.profileGradient : null,
        color: isOwned ? null : AppColorStyles.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.xLarge),
        boxShadow: [shadow],
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage(
                    pet.avatar.isNotEmpty
                        ? pet.avatar
                        : pet.species == PetSpecies.dog
                        ? 'assets/images/dog.png'
                        : pet.species == PetSpecies.cat
                        ? 'assets/images/cat.png'
                        : 'assets/images/placeholder.png',
                  ),
                ),

                SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      capitalizeFirst(pet.name),
                      style: AppTextStyles.bodyBase.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      capitalizeFirst(pet.gender),
                      style: AppTextStyles.bodyExtraSmall.copyWith(
                        color: AppColorStyles.lightGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            Chip(
              label: Text(
                capitalizeFirst(pet.breed),
                style: AppTextStyles.bodyExtraSmall,
              ),
              backgroundColor: AppColorStyles.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(width: 0),
              ),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
