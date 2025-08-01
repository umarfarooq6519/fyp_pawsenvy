import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/utils/text.util.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/theme/theme.dart';
import 'package:fyp_pawsenvy/core/models/pet.dart';

class PetProfileSmall extends StatelessWidget {
  final Pet pet;

  const PetProfileSmall({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    final String name = pet.name;
    final species = pet.species;
    final String gender = pet.gender;
    final String breed = pet.breed;

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
      ),
      child: Stack(
        children: [
          Material(
            color: AppColorStyles.transparent,
            borderRadius: BorderRadius.circular(28),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 90,
                    child: Center(
                      child: CircleAvatar(
                        radius: 36,
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
                    ),
                  ),
                  const SizedBox(height: 12),
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
                      capitalizeFirst(name),
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${capitalizeFirst(breed)} - ${capitalizeFirst(gender)}',
                    style: AppTextStyles.bodyExtraSmall.copyWith(
                      color: AppColorStyles.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
