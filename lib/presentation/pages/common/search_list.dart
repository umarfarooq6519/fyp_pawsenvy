import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/presentation/widgets/pet_profile_screen.dart';
import 'package:fyp_pawsenvy/presentation/widgets/search_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../../widgets/profile_small.dart';

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
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // Search/filter bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(child: CustomSearchBar()),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.15),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: IconButton(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    color: Colors.black,
                    padding: EdgeInsets.all(15),
                    icon: const Icon(LineIcons.filter, color: Colors.black54),
                    onPressed: onFilter,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // List of cards
          Expanded(
            child: ListView.builder(
              itemCount: components.length,
              itemBuilder: (context, index) {
                final item = components[index];
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ProfileSmall(
                    name: item['name'] ?? '',
                    image: item['avatar'] ?? 'assets/images/placeholder.png',
                    tag1: item['role'] ?? '',
                    tag2: item['location'] ?? '',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PetProfileScreen(profile: item),
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
