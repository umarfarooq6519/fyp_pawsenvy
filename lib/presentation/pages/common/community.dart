import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/router/routes.dart';
import 'package:fyp_pawsenvy/core/theme/theme.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/data/pets.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/service_card.dart';

class Community extends StatelessWidget {
  const Community({super.key});

  @override
  Widget build(BuildContext context) {
    // Removed unused veterinarians variable
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
      ), // was pagePadding
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.huge,
          ), // was EdgeInsets.symmetric(vertical: 40)
          child: Column(
            children: [
              Text('Community', style: AppTextStyles.headingLarge),
              const SizedBox(height: 3),
              Text(
                'Care, Love, and Tail-Wagging Happiness!',
                style: AppTextStyles.headingSmall.copyWith(
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ServiceCard(
              image: 'assets/images/adoption.png',
              label: 'Adoption',
              onTap: () {
                context.push(
                  Routes.searchList,
                  extra: {'title': 'Adoption', 'components': pets},
                );
              },
            ),
            const SizedBox(width: 18),
            ServiceCard(
              image: 'assets/images/veterinary.png',
              label: 'Veterinary',
              onTap: () {
                context.push(
                  Routes.searchList,
                  extra: {'title': 'Adoption', 'components': pets},
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Nearby Pet Care', style: AppTextStyles.headingMedium),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: AppTextStyles.bodyBase.copyWith(color: Colors.black54),
              ),
            ),
          ],
        ),
        // ...petCares.map(
        //   (care) => ExtendedCard(
        //     title: care['name'] ?? '',
        //     tags:
        //         (care['pets'] != null)
        //             ? (care['pets'] is String
        //                 ? (care['pets'] as String)
        //                     .split('|')
        //                     .map((e) => e.trim())
        //                     .toList()
        //                 : care['pets'] as List<String>?)
        //             : null,
        //     trailing: care['distance'] ?? '',
        //     avatar: care['avatar'],
        //   ),
        // ),
      ],
    );
  }
}
