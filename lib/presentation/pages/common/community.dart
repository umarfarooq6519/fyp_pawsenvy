import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/router/routes.dart';
import 'package:fyp_pawsenvy/core/theme/theme.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
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
            const SizedBox(width: 18),
            ServiceCard(
              image: 'assets/images/adoption.png',
              label: 'Adoption',
              onTap: () {
                context.push(Routes.adoptionPets);
              },
            ),
            SizedBox(width: 8),
            ServiceCard(
              image: 'assets/images/veterinary.png',
              label: 'Lost & Found',
              onTap: () {
                context.push(Routes.lostFoundPets);
              },
            ),
          ],
        ),
      ],
    );
  }
}
