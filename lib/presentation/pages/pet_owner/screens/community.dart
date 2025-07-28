import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/router/routes.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/presentation/widgets/common/search_bar.dart';
import 'package:fyp_pawsenvy/providers/user.provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  late AppUser? _user;

  @override
  Widget build(BuildContext context) {
    _user = context.watch<UserProvider>().user;

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi ${_user!.name.split(' ')[0]},',
                    style: AppTextStyles.headingExtraLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColorStyles.grey,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    'How can I help \nyou today?',
                    style: AppTextStyles.headingMain.copyWith(height: 1.1),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            CustomSearchBar(),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _communityCard(
                  'assets/images/animal-shelter.png',
                  'Adoption',
                  'Find Your new best friend',
                  () {
                    context.push(Routes.adoptionPets);
                  },
                ),

                SizedBox(width: 8),

                _communityCard(
                  'assets/images/finding.png',
                  'Lost & Found',
                  'Help reunite pets with owners',
                  () {
                    context.push(Routes.lostFoundPets);
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _communityCard(
                  'assets/images/pet-care.png',
                  'Partner Finder',
                  'Match pets for breeding safely',
                  () {
                    context.push(Routes.petPartnerFinder);
                  },
                ),

                SizedBox(width: 8),

                _communityCard(
                  'assets/images/veterinarian.png',
                  'Veterinarians',
                  'Book trusted vet services fast',
                  () {},
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _communityCard(
    String imagePath,
    String label,
    String subLabel,
    GestureTapCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 160,
          width: double.infinity,
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColorStyles.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColorStyles.lightPurple),
            boxShadow: [
              BoxShadow(
                color: AppColorStyles.lightPurple.withOpacity(0.15),
                spreadRadius: 0,
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(image: AssetImage(imagePath), width: 42, height: 42),
              SizedBox(height: 10),
              Text(label, style: AppTextStyles.headingSmall),
              SizedBox(height: 2),
              Text(
                subLabel,
                style: AppTextStyles.bodyExtraSmall.copyWith(
                  color: AppColorStyles.grey,
                ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
