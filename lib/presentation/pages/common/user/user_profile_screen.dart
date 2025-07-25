import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key, required this.user});
  final AppUser user;

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
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.white,
                          backgroundImage:
                              user.avatar.isNotEmpty
                                  ? NetworkImage(user.avatar)
                                  : const AssetImage(
                                        'assets/images/person1.png',
                                      )
                                      as ImageProvider,
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
                                  user.name.isNotEmpty
                                      ? user.name
                                      : 'No name given :(',
                                  style: AppTextStyles.headingMedium,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          user.userRole == UserRole.vet
                                              ? LineIcons.stethoscope
                                              : LineIcons.paw,
                                          size: 18,
                                          color: AppColorStyles.black,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          user.userRole == UserRole.vet
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
                                        FutureBuilder<String>(
                                          future: _getLocationNameFromGeoPoint(
                                            user.location,
                                          ),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Text(
                                                'Fetching location...',
                                                style: AppTextStyles.bodySmall,
                                              );
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                'Error fetching location',
                                                style: AppTextStyles.bodySmall,
                                              );
                                            } else {
                                              return Text(
                                                snapshot.data ??
                                                    'Unknown Location',
                                                style: AppTextStyles.bodySmall,
                                              );
                                            }
                                          },
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildAttributeItem(
                              context,
                              LineIcons.paw,
                              '${user.ownedPets.length} Pets',
                            ),
                            _buildAttributeItem(
                              context,
                              LineIcons.heart,
                              '${user.likedPets.length} Liked',
                            ),
                            _buildAttributeItem(
                              context,
                              LineIcons.calendar,
                              '${DateTime.now().year - user.dob.year} years',
                            ),
                            if (user.userRole == UserRole.vet &&
                                user.vetProfile != null)
                              _buildAttributeItem(
                                context,
                                LineIcons.stethoscope,
                                'Verified',
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('About', style: AppTextStyles.headingSmall),
                      const SizedBox(height: 8),
                      Text(
                        user.bio.isNotEmpty ? user.bio : 'No bio available',
                        style: AppTextStyles.bodyBase,
                      ),
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
                onPressed: () {
                  // Contact logic will be implemented later
                },
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

  Future<String> _getLocationNameFromGeoPoint(GeoPoint coordinates) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        coordinates.latitude,
        coordinates.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return "${placemark.locality}, ${placemark.administrativeArea}";
      } else {
        return "Unknown Location";
      }
    } catch (e) {
      return "Error fetching location: $e";
    }
  }

  Widget _buildAttributeItem(
    BuildContext context,
    IconData icon,
    String label,
  ) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}
