import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/pet.dart';
import 'package:fyp_pawsenvy/core/services/auth.service.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/presentation/widgets/common/search_bar.dart';
import 'package:fyp_pawsenvy/presentation/widgets/profiles/pet/pet_profile_small.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class OwnerDashboard extends StatefulWidget {
  const OwnerDashboard({super.key});

  @override
  State<OwnerDashboard> createState() => _OwnerDashboardState();
}

class _OwnerDashboardState extends State<OwnerDashboard> {
  late AuthService _auth;

  @override
  void initState() {
    super.initState();
    _auth = Provider.of<AuthService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final DBService _db = Provider.of<DBService>(context, listen: false);

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Evening,',
                style: AppTextStyles.headingLarge.copyWith(
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                _auth.currentUser?.displayName ?? 'Guest',
                style: AppTextStyles.headingLarge,
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomSearchBar(),
        ),

        SizedBox(height: 30),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Recent Pets', style: AppTextStyles.headingMedium),
        ),

        SizedBox(height: 10),

        StreamBuilder<List<Pet>>(
          stream: _db.getAllPetsStream(),
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
                    Text('No pets found 😔'),
                  ],
                ),
              );
            }

            return SizedBox(
              height: 240,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  final Pet pet = pets[index];
                  return GestureDetector(
                    onTap:
                        () => GoRouter.of(
                          context,
                        ).push('/pet-profile', extra: pet),
                    child: PetProfileSmall(pet: pet),
                  );
                },
              ),
            );
          },
        ),

        SizedBox(height: 25),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Upcoming Events', style: AppTextStyles.headingMedium),
        ),
      ],
    );
  }
}
