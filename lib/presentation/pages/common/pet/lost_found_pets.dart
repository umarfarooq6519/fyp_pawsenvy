import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/pet.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/presentation/widgets/profiles/pet_profile_extended.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';

class LostFoundPets extends StatelessWidget {
  const LostFoundPets({super.key});

  @override
  Widget build(BuildContext context) {
    final DBService db = DBService();

    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<List<Pet>>(
        stream: db.getLostFoundPetsStream(),
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
                  Text('No pets marked as lost'),
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
                    Text(
                      'Lost & Found Pets',
                      style: AppTextStyles.headingLarge,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Join efforts to bring lost pets back home safe & secure',
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
