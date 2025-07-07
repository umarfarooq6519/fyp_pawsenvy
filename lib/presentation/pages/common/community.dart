import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/search_list.dart';
import '../../../data/users.dart';
import '../../../data/pets.dart';
import '../../../data/pet_cares.dart';
import '../../widgets/extended_card.dart';

class Community extends StatelessWidget {
  Community({super.key});

  final vets =
      users
          .where((i) => (i['role'] ?? '').toLowerCase().contains('vet'))
          .toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Removed unused veterinarians variable
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Text(
                'Community',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Care, Love, and Tail-Wagging Happiness!',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w300,
                  height: 0,
                ),
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
            Text(
              'Nearby Pet Care',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
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
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
