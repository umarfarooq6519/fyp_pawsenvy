import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';

class UserProfileLarge extends StatelessWidget {
  const UserProfileLarge({super.key, required this.user});
  final Map<String, dynamic> user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              // Avatar section
              Container(
                width: double.infinity,
                height: 240,
                decoration: BoxDecoration(
                  gradient: AppColorStyles.profileGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: SafeArea(
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          user['avatar'] ?? 'assets/images/placeholder.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  LineIcons.arrowLeft,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              IconButton(
                                icon: Icon(
                                  LineIcons.verticalEllipsis,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
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
                                const SizedBox(height: 0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          user['role'] == 'veterinary'
                                              ? LineIcons.stethoscope
                                              : LineIcons.paw,
                                          size: 18,
                                          color: AppColorStyles.black,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          user['role'] == 'veterinary'
                                              ? 'Veterinary'
                                              : 'Pet Owner',
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: AppColorStyles.black,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Text(' - '),
                                    Row(
                                      children: [
                                        Icon(
                                          LineIcons.mapMarker,
                                          size: 18,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.onSurfaceVariant,
                                        ),
                                        Text(
                                          user['location'] ?? '',
                                          style: AppTextStyles.bodySmall,
                                        ),
                                      ],
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
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
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
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColorStyles.lightPurple),
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorStyles.purple,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 2,
                  shadowColor: AppColorStyles.black,
                ),
                onPressed: () {},
                icon: Icon(
                  LineIcons.phone,
                  color: AppColorStyles.white,
                  size: 20,
                ),
                label: Text(
                  'Contact',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColorStyles.white,
                    fontWeight: FontWeight.w500,
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
