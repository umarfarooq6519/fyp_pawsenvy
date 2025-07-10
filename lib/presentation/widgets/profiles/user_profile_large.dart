import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fyp_pawsenvy/core/utils/colors.dart';
import 'package:fyp_pawsenvy/core/utils/text_styles.dart';

class UserProfileLarge extends StatelessWidget {
  const UserProfileLarge({super.key, required this.user});
  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          Column(
            children: [
              // Avatar section
              Container(
                width: double.infinity,
                height: 320,
                decoration: BoxDecoration(
                  gradient: AppColors.profileGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: AssetImage(
                          user['avatar'] ?? 'assets/images/placeholder.png',
                        ),
                        backgroundColor: Theme.of(context).colorScheme.surface,
                      ),
                    ),
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
              // Details section
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
                                  user['name'] ?? '',
                                  style: AppTextStyles.headingMedium,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      user['role'] == 'veterinary'
                                          ? LineIcons.stethoscope
                                          : LineIcons.paw,
                                      size: 18,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      user['role'] == 'veterinary'
                                          ? 'Veterinary'
                                          : 'Pet Owner',
                                      style: AppTextStyles.headingSmall
                                          .copyWith(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                          ),
                                    ),
                                  ],
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
                                      user['location'] ?? '',
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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
                            (user['attributes'] as List).length,
                            (i) {
                              final attr =
                                  (user['attributes'] as List)[i]
                                      as Map<String, dynamic>;
                              return Column(
                                children: [
                                  _buildAttributeIcon(attr['icon'], context),
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
                      Text('About', style: AppTextStyles.headingSmall),
                      const SizedBox(height: 8),
                      Text(user['about'] ?? '', style: AppTextStyles.bodyBase),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ), // Sticky contact button
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.profileGradient,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.deepPurpleBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement contact action
                  },
                  icon: Icon(LineIcons.commentDots, color: Colors.black),
                  label: Text(
                    'Contact',
                    style: AppTextStyles.buttonText.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeIcon(dynamic icon, BuildContext context) {
    if (icon == null) {
      return const SizedBox(height: 36, width: 36);
    }
    if (icon is String) {
      return CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Image.asset(icon, width: 28, height: 28),
      );
    }
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Icon(
        icon as IconData,
        color: Theme.of(context).colorScheme.primary,
        size: 24,
      ),
    );
  }
}
