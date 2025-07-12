import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/theme/colors.dart';
import 'package:fyp_pawsenvy/core/theme/text_styles.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:line_icons/line_icons.dart';
import '../../../data/pets.dart';
import '../../widgets/profiles/profile_medium.dart';

class YourPetsScreen extends StatefulWidget {
  const YourPetsScreen({super.key});

  @override
  State<YourPetsScreen> createState() => _YourPetsScreenState();
}

class _YourPetsScreenState extends State<YourPetsScreen> {
  int _activePetIndex = 0;
  int _selectedChip = 0;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> displayedPets = pets;
    final double chipSpacing = 16;
    final double plusChipWidth = 48;
    final double chipWidth =
        (MediaQuery.of(context).size.width -
            2 * 20 -
            2 * chipSpacing -
            plusChipWidth) /
        2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Plus chip first
            _buildGradientChip(
              width: plusChipWidth,
              icon: LineIcons.plus,
              selected: true,
              onTap: () {},
            ),
            SizedBox(width: chipSpacing),
            _buildGradientChip(
              width: chipWidth,
              icon: LineIcons.paw,
              label: 'Owned',
              selected: _selectedChip == 0,
              onTap: () => setState(() => _selectedChip = 0),
            ),
            SizedBox(width: chipSpacing),
            _buildGradientChip(
              width: chipWidth,
              icon: LineIcons.heart,
              label: 'Liked',
              selected: _selectedChip == 1,
              onTap: () => setState(() => _selectedChip = 1),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 500,
          child: Swiper(
            itemCount: displayedPets.length,
            itemBuilder: (context, index) {
              final pet = displayedPets[index];
              return ProfileMedium(
                name: pet['name'] ?? '',
                image: pet['avatar'] ?? 'assets/images/placeholder.png',
                type: pet['type'] ?? '',
                about: pet['about'] ?? '',
                tag1: pet['gender'],
                tag2: pet['location'],
                verified: true,
                isFavorite: false,
                onTap: () {},
                onFavorite: () {},
              );
            },
            onIndexChanged: (i) => setState(() => _activePetIndex = i),
            viewportFraction: 0.8,
            scale: 0.92,
            loop: true,
          ),
        ),
        const SizedBox(height: 18),
        AnimatedSmoothIndicator(
          activeIndex: _activePetIndex,
          count: displayedPets.length,
          effect: ExpandingDotsEffect(
            dotHeight: 10,
            dotWidth: 10,
            activeDotColor: Colors.deepPurple,
            dotColor: Colors.deepPurple.shade100,
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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
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
                style: AppTextStyles.bodyBase.copyWith(
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
