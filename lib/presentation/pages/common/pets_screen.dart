import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fyp_pawsenvy/core/router/routes.dart';

import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:line_icons/line_icons.dart';
import '../../../core/models/pet.dart';
import '../../../core/services/auth.service.dart';
import '../../../core/services/db.service.dart';
import '../../widgets/profiles/profile_medium.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  int _activePetIndex = 0;
  int _selectedView = 0;

  List<Pet> _ownedPets = [];
  List<Pet> _likedPets = [];

  bool _isLoading = true; // true by default

  final double _cardSizedBoxHeight = 450;

  @override
  void initState() {
    super.initState();
    _handleFetchOwnedPets();
  }

  Future<void> _handleFetchOwnedPets() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final dbService = Provider.of<DBService>(context, listen: false);
      final currentUser = authService.currentUser;

      if (currentUser != null) {
        final ownedPets = await dbService.fetchUserOwnedPets(currentUser.uid);
        final likedPets = await dbService.fetchUserLikedPets(currentUser.uid);

        setState(() {
          _ownedPets = ownedPets;
          _likedPets = likedPets;
        });
      }
    } catch (e) {
      print('Error loading pets: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current list based on selected chip
    final List<Pet> currentPets = _selectedView == 0 ? _ownedPets : _likedPets;

    final double chipSpacing = 16;
    final double plusChipWidth = 48;
    final double chipWidth =
        (MediaQuery.of(context).size.width -
            2 * 20 -
            2 * chipSpacing -
            plusChipWidth) /
        2;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Plus chip first
              _buildGradientChip(
                width: plusChipWidth,
                icon: LineIcons.plus,
                selected: true,
                onTap: () {
                  GoRouter.of(context).push('/create-pet-profile');
                },
              ),
              SizedBox(width: chipSpacing),
              _buildGradientChip(
                width: chipWidth,
                icon: LineIcons.paw,
                label: 'Owned',
                selected: _selectedView == 0,
                onTap:
                    () => setState(() {
                      _selectedView = 0;
                      _activePetIndex = 0; // Reset active index
                    }),
              ),
              SizedBox(width: chipSpacing),
              _buildGradientChip(
                width: chipWidth,
                icon: LineIcons.heart,
                label: 'Liked',
                selected: _selectedView == 1,
                onTap:
                    () => setState(() {
                      _selectedView = 1;
                      _activePetIndex = 0; // Reset active index
                    }),
              ),
            ],
          ),
        ),
        currentPets.isEmpty
            ? SizedBox(
              height: _cardSizedBoxHeight,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _selectedView == 0 ? LineIcons.paw : LineIcons.heart,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _selectedView == 0
                          ? 'No pets owned yet'
                          : 'No liked pets yet',
                      style: AppTextStyles.headingSmall.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedView == 0
                          ? 'Tap the + button to add your first pet!'
                          : 'Start liking pets to see them here',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
            : SizedBox(
              height: _cardSizedBoxHeight,
              child: Swiper(
                itemCount: currentPets.length,
                itemBuilder: (context, index) {
                  final pet = currentPets[index];
                  // Build the profile map for ProfileMedium
                  final Map<String, dynamic> profile = {
                    'name': pet.name,
                    'image':
                        pet.avatar.isNotEmpty
                            ? pet.avatar
                            : 'assets/images/placeholder.png',
                    'type': '${pet.species.name.toUpperCase()} • ${pet.breed}',
                    'about':
                        pet.bio.isNotEmpty
                            ? pet.bio
                            : 'No description available',
                    'tag1': pet.gender,
                    'tag2': '${pet.age} years old',
                    'verified': true,
                  };
                  return GestureDetector(
                    onTap: () {
                      context.push(Routes.petProfile, extra: pet);
                    },
                    child: ProfileMedium(profile: profile),
                  );
                },
                onIndexChanged: (i) => setState(() => _activePetIndex = i),
                viewportFraction: 0.8,
                scale: 0.92,
                loop: currentPets.length > 1,
              ),
            ),
        if (currentPets.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Center(
              child: AnimatedSmoothIndicator(
                activeIndex: _activePetIndex,
                count: currentPets.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  activeDotColor: Colors.deepPurple,
                  dotColor: Colors.deepPurple.shade100,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildGradientChip({
    required double width,
    required IconData icon,
    String? label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final gradient = const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Color(0xFFF6D6E6), Color(0xFFE6FBFA)],
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        decoration: BoxDecoration(
          gradient: selected ? gradient : null,
          color: selected ? null : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColorStyles.lightPurple : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: Color(0xFFF6D6E6),
                      blurRadius: 5,
                      spreadRadius: 0,
                    ),
                  ]
                  : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? Colors.deepPurple : Colors.black54,
              size: 22,
            ),
            if (label != null && label.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: selected ? Colors.deepPurple : Colors.black54,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
