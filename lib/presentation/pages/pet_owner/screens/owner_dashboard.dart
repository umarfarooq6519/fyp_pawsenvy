import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/router/routes.dart';
import 'package:fyp_pawsenvy/core/utils/text_styles.dart';
import 'package:fyp_pawsenvy/core/theme/app_theme.dart';
import 'package:fyp_pawsenvy/data/pets.dart';
import 'package:fyp_pawsenvy/data/users.dart';
import 'package:fyp_pawsenvy/presentation/widgets/common/search_bar.dart';
import 'package:fyp_pawsenvy/presentation/widgets/profiles/profile_small.dart';
import 'package:go_router/go_router.dart';

class OwnerDashboard extends StatelessWidget {
  const OwnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // ######### Good wishes
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl).copyWith(
            top: AppSpacing.huge,
            bottom: AppSpacing.huge,
          ), // was pagePadding
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
        ), // ####### Search bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: CustomSearchBar(),
        ),
        SizedBox(height: AppSpacing.huge), // was massive
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
          ), // was pagePadding
          child: Text('Your Pets', style: AppTextStyles.headingMedium),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.xs,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: pets.length,
            itemBuilder: (context, index) {
              final pet = pets[index];
              final attributes = pet['attributes'] as List<dynamic>?;
              Map<String, dynamic>? genderAttribute;
              if (attributes != null && attributes.isNotEmpty) {
                genderAttribute = attributes
                    .cast<Map<String, dynamic>?>()
                    .firstWhere(
                      (attr) =>
                          (attr?['label'] as String?)?.toLowerCase().contains(
                                'male',
                              ) ==
                              true ||
                          (attr?['label'] as String?)?.toLowerCase().contains(
                                'female',
                              ) ==
                              true,
                      orElse: () => attributes.first as Map<String, dynamic>?,
                    );
              }

              return ProfileSmall(
                name: pet['name'],
                image: pet['avatar'],
                tag1: pet['breed'],
                tag2:
                    genderAttribute != null
                        ? genderAttribute['label'] ?? ''
                        : '',
                onTap: () {
                  context.push(Routes.petProfile, extra: pet);
                },
              );
            },
          ),
        ),
        SizedBox(height: AppSpacing.xl),
        // User profiles horizontal list
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
          ), // was pagePadding
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
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.xs,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ProfileSmall(
                name: user['name'],
                image: user['avatar'],
                tag1: user['role'],
                tag2: user['location'],
                onTap: () {
                  context.push(Routes.userProfile, extra: user);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
