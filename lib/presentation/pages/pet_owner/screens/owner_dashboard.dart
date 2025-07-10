import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/utils/text_styles.dart';
import 'package:fyp_pawsenvy/data/pets.dart';
import 'package:fyp_pawsenvy/data/users.dart';
import 'package:fyp_pawsenvy/presentation/widgets/common/search_bar.dart';
import 'package:fyp_pawsenvy/presentation/widgets/profiles/pet_profile_large.dart';
import 'package:fyp_pawsenvy/presentation/widgets/profiles/user_profile_large.dart';
import 'package:fyp_pawsenvy/presentation/widgets/profiles/profile_small.dart';

class OwnerDashboard extends StatelessWidget {
  const OwnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // ######### Good wishes
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Evening,',
                style: AppTextStyles.headingLarge.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text('Umar', style: AppTextStyles.headingLarge),
            ],
          ),
        ),

        // ####### Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomSearchBar(),
        ),
        SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Your Pets', style: AppTextStyles.headingMedium),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
            scrollDirection: Axis.horizontal,
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              final attributes = pet['attributes'] ?? [];
              final gender = attributes.firstWhere(
                (attr) =>
                    (attr['label'] as String).toLowerCase().contains('male') ||
                    (attr['label'] as String).toLowerCase().contains('female'),
                orElse: () => <String, Object>{},
              );
              final String genderLabel = gender['label']?.toString() ?? '';
              return ProfileSmall(
                name: pet['name'] ?? '',
                image:
                    pet['image'] ??
                    (pet['type'] == 'Dog'
                        ? 'assets/images/dog.png'
                        : pet['type'] == 'Cat'
                        ? 'assets/images/cat.png'
                        : 'assets/images/placeholder.png'),
                tag1: pet['breed'] ?? pet['type'] ?? '',
                tag2: genderLabel,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PetProfileLarge(profile: pet),
                    ),
                  );
                },
              );
            },
          ),
        ),
        SizedBox(height: 20),
        // User profiles horizontal list
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Users', style: AppTextStyles.headingMedium),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
            scrollDirection: Axis.horizontal,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ProfileSmall(
                name: user['name'] ?? '',
                image: user['avatar'] ?? 'assets/images/placeholder.png',
                tag1: user['role'] ?? '',
                tag2: user['location'] ?? '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileLarge(user: user),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
