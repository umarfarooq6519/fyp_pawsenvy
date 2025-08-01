import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/router/routes.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/presentation/widgets/profiles/vet/vet_profile_extended.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class VetListing extends StatelessWidget {
  const VetListing({super.key});

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DBService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              children: [
                Text('Veterinarians', style: AppTextStyles.headingLarge),
                const SizedBox(height: 5),
                Text(
                  'Where compassion meets clinical excellence',
                  style: AppTextStyles.headingSmall.copyWith(
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<List<AppUser>>(
              stream: dbService.getAllVetsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error loading veterinarians: ${snapshot.error}',
                      style: AppTextStyles.bodyBase,
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final vets = snapshot.data ?? [];

                if (vets.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_hospital,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No veterinarians found',
                          style: AppTextStyles.headingSmall.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Check back later for available vets in your area',
                          style: AppTextStyles.bodyBase.copyWith(
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: vets.length,
                  itemBuilder: (context, index) {
                    final vet = vets[index];
                    return GestureDetector(
                      onTap:
                          () => {context.push(Routes.userProfile, extra: vet)},
                      child: VetProfileExtended(vet: vet),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
