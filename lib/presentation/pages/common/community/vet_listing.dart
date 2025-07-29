import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/data/vets.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/presentation/widgets/profiles/vet/vet_profile_extended.dart';

class VetListing extends StatelessWidget {
  const VetListing({super.key});
  @override
  Widget build(BuildContext context) {
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
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dummyVets.length,
              itemBuilder: (context, index) {
                final vet = dummyVets[index];
                return VetProfileExtended(vet: vet);
              },
            ),
          ),
        ],
      ),
    );
  }
}
