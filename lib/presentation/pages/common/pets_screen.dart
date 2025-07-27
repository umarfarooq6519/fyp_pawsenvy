import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/models/pet.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:fyp_pawsenvy/providers/user.provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:line_icons/line_icons.dart';
import '../../widgets/profiles/pet/pet_profile_medium.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

enum PetViewType { owned, liked }

class _PetsScreenState extends State<PetsScreen> {
  late DBService _db;
  late AppUser? _appUser;

  late List<String> petIDs;

  PetViewType _selectedView = PetViewType.owned;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // call the providers
    _db = Provider.of<DBService>(context, listen: false);
    _appUser = context.watch<UserProvider>().user;
  }

  @override
  Widget build(BuildContext context) {
    final isOwned = _selectedView == PetViewType.owned;
    petIDs = isOwned ? _appUser?.ownedPets ?? [] : _appUser?.likedPets ?? [];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => GoRouter.of(context).push('/create-pet-profile'),
                child: Chip(
                  label: Text(
                    'Add',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColorStyles.white,
                    ),
                  ),
                  avatar: Icon(LineIcons.plus, color: AppColorStyles.white),
                  backgroundColor: AppColorStyles.deepPurple,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _selectedView = PetViewType.owned),
                child: Chip(
                  label: Text(
                    'Owned Pets',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColorStyles.black,
                    ),
                  ),
                  avatar: Icon(LineIcons.paw, color: AppColorStyles.black),
                  backgroundColor:
                      isOwned
                          ? AppColorStyles.pastelRed
                          : AppColorStyles.transparent,
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _selectedView = PetViewType.liked),
                child: Chip(
                  label: Text(
                    'Liked Pets',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColorStyles.black,
                    ),
                  ),
                  avatar: Icon(LineIcons.heart, color: AppColorStyles.black),
                  backgroundColor:
                      !isOwned
                          ? AppColorStyles.pastelRed
                          : AppColorStyles.transparent,
                ),
              ),
            ],
          ),
        ),

        StreamBuilder<List<Pet>>(
          stream: _db.getPetsStreamByIDs(petIDs),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(isOwned ? 'No Owned Pets 😔' : 'No Liked Pets 😔'),
              );
            }
            final pets = snapshot.data!;
            return Column(
              children: [
                SizedBox(
                  height: 420,
                  child: Swiper(
                    loop: pets.length < 2 ? false : true,
                    itemBuilder: (BuildContext context, int index) {
                      final Pet pet = pets[index];
                      return GestureDetector(
                        onTap:
                            () => GoRouter.of(
                              context,
                            ).push('/pet-profile', extra: pet),
                        child: PetProfileMedium(pet: pet),
                      );
                    },
                    itemCount: pets.length,
                    viewportFraction: 0.77,
                    scale: 0.9,
                    layout: SwiperLayout.DEFAULT,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
