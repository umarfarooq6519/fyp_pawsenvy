import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fyp_pawsenvy/core/utils/colors.dart';
import 'package:fyp_pawsenvy/core/utils/text_styles.dart';

class PetProfileLarge extends StatelessWidget {
  const PetProfileLarge({super.key, required this.profile});

  final Map<String, dynamic> profile;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          // Main content with scroll
          Column(
            children: [
              // ####### Profile image with full width and fixed height
              Container(
                width: double.infinity,
                height: 340,
                decoration: BoxDecoration(
                  gradient: AppColors.profileGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Stack(
                  children: [
                    // Show cat or dog image based on profile type
                    Align(
                      alignment: Alignment.center,
                      child: _displayImage(profile),
                    ),
                    // Top bar
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(
                                LineIcons.arrowLeft,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            IconButton(
                              icon: Icon(
                                LineIcons.verticalEllipsis,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ############# Details (scrollable)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile['name'] as String,
                                  style: AppTextStyles.headingMedium,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      LineIcons.mapMarker,
                                      size: 16,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      profile['location'] as String,
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              LineIcons.heart,
                              color: Colors.red,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const SizedBox(height: 16),
                      // Attributes
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            (profile['attributes'] as List).length,
                            (i) {
                              final attr =
                                  (profile['attributes'] as List)[i]
                                      as Map<String, dynamic>;
                              return Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    child: Icon(
                                      attr['icon'] as IconData,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    attr['label'] as String,
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('About this pet', style: AppTextStyles.headingSmall),
                      const SizedBox(height: 8),
                      Text(
                        profile['about'] as String,
                        style: AppTextStyles.bodyBase,
                      ),
                      const SizedBox(height: 100), // Space for button
                    ],
                  ),
                ),
              ),
            ],
          ), // Sticky Adopt button
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppColors.profileGradient,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.deepPurpleBorder),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {},
                child: Text(
                  'Adopt this pet',
                  style: AppTextStyles.buttonText.copyWith(color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Image _displayImage(Map<String, Object?> profile) {
    final type = profile['type'];

    return Image.asset(
      type == 'Dog'
          ? 'assets/images/dog.png'
          : type == 'Cat'
          ? 'assets/images/cat.png'
          : 'assets/images/placeholder.png',
      fit: BoxFit.cover,
    );
  }
}
