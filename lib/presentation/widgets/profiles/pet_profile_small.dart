import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
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
                        radius: 32,
                        backgroundImage: AssetImage(
                          species == PetSpecies.dog
                              ? 'assets/images/dog.png'
                              : 'assets/images/dog.png',
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
                      color: AppColorStyles.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColorStyles.lightPurple),
                    ),
                    child: Text(
                      name,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$gender - $breed',
                    style: AppTextStyles.bodyExtraSmall.copyWith(
                      color: AppColorStyles.lightGrey,
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
