import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/router/routes.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/community_card.dart';

class Community extends StatefulWidget {
  const Community({super.key});

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 34),
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
            CommunityCard(
              image: 'assets/images/adoption.png',
              label: 'Adoption',
              onTap: () {
                context.push(Routes.adoptionPets);
              },
            ),
            SizedBox(width: 8),
            CommunityCard(
              image: 'assets/images/veterinary.png',
              label: 'Lost & Found',
              onTap: () {
                context.push(Routes.lostFoundPets);
              },
            ),
          ],
        ),

        SizedBox(height: 34),

        // ################# Veterinarians
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Veterinarians', style: AppTextStyles.headingMedium),
            TextButton(
              onPressed: () {},
              child: Text('View all', style: AppTextStyles.bodySmall),
            ),
          ],
        ),
      ],
    );
  }
}
