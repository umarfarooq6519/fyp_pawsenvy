import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/pet.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/presentation/widgets/profiles/pet/pet_profile_extended.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';

class AdoptionPets extends StatelessWidget {
  const AdoptionPets({super.key});

  @override
  Widget build(BuildContext context) {
    final DBService db = DBService();

    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<List<Pet>>(
        stream: db.getAdoptionPetsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching pets.'));
          }

          final pets = snapshot.data;

          if (pets == null || pets.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LineIcons.paw, size: 40),
                  SizedBox(height: 4),
                  Text('No pets up for adoption'),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                child: Column(
                  children: [
                    Text('Adopt a Pet', style: AppTextStyles.headingLarge),
                    const SizedBox(height: 5),
                    Text(
                      'Find your perfect companion and give them a loving home',
                      style: AppTextStyles.headingSmall.copyWith(
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    final Pet pet = pets[index];
                    return GestureDetector(
                      onTap:
                          () => GoRouter.of(
                            context,
                          ).push('/pet-profile', extra: pet),
                      child: PetProfileExtended(pet: pet),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
