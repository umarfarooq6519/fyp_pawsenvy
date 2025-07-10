import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/utils/text_styles.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/search_list.dart';
import '../../../data/users.dart';
import '../../../data/pets.dart';
import '../../../data/pet_cares.dart';
import '../../widgets/profiles/profile_extended.dart';

class Community extends StatelessWidget {
  Community({super.key});

  final vets =
      users
          .where((i) => (i['role'] ?? '').toLowerCase().contains('vet'))
          .toList();
  @override
  Widget build(BuildContext context) {
    // Removed unused veterinarians variable
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
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
            _ServiceCard(
              image: 'assets/images/adoption.png',
              label: 'Adoption',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => SearchList(
                          searchController: TextEditingController(),
                          title: 'Adoption Pets',
                          onSearch: () {},
                          onFilter: () {},
                          components: pets,
                        ),
                  ),
                );
              },
            ),
            const SizedBox(width: 18),
            _ServiceCard(
              image: 'assets/images/veterinary.png',
              label: 'Veterinary',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => SearchList(
                          searchController: TextEditingController(),
                          title: 'Veterinary',
                          onSearch: () {},
                          onFilter: () {},
                          components: vets,
                        ),
                  ),
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
        ...petCares.map(
          (care) => ExtendedCard(
            title: care['name'],
            tags:
                (care['pets'] is String)
                    ? (care['pets'] as String)
                        .split('|')
                        .map((e) => e.trim())
                        .toList()
                    : (care['pets'] as List<String>?),
            trailing: care['distance'],
            avatar: care['avatar'],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback? onTap;
  const _ServiceCard({required this.image, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color.fromARGB(255, 219, 216, 236),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(image, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.bodyBase),
          ],
        ),
      ),
    );
  }
}
