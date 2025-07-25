import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/models/pet.dart';
import 'package:fyp_pawsenvy/presentation/widgets/common/search_with_filter.dart';
import 'package:fyp_pawsenvy/presentation/widgets/profiles/pet_profile_large.dart';
import 'package:fyp_pawsenvy/core/theme/theme.dart';

import '../../widgets/profiles/profile_small.dart';

class SearchList extends StatelessWidget {
  final TextEditingController searchController;
  final String title;
  final VoidCallback onSearch;
  final VoidCallback onFilter;
  final List<Map<String, dynamic>> components;

  const SearchList({
    super.key,
    required this.searchController,
    required this.onSearch,
    required this.onFilter,
    required this.components,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title, style: AppTextStyles.headingMedium),
      ),
      body: Column(
        children: [
          // Search/filter bar
          SearchWithFilter(
            searchController: searchController,
            onFilterPressed: onFilter,
          ),
          const SizedBox(height: AppSpacing.md),
          // List of cards
          Expanded(
            child: ListView.builder(
              itemCount: components.length,
              itemBuilder: (context, index) {
                final item = components[index];
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: ProfileSmall(
                    name: item['name'] ?? '',
                    image: item['avatar'] ?? 'assets/images/placeholder.png',
                    tag1: item['role'] ?? '',
                    tag2: item['location'] ?? '',
                    onTap: () {
                      // Convert the map item to a Pet object first
                      // This is a temporary solution - ideally search should work with Pet objects
                      final pet = Pet.fromMap(item);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetProfileLarge(pet: pet),
                        ),
                      );
                    },
                    onFavorite: item['onFavorite'],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
