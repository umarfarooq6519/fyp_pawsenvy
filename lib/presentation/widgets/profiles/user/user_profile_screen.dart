import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/pet.dart';
import 'package:fyp_pawsenvy/core/router/routes.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/core/utils/text.util.dart';
import 'package:fyp_pawsenvy/core/models/vet_profile.dart';
import 'package:geocoding/geocoding.dart';
import 'package:line_icons/line_icons.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:provider/provider.dart';
import 'package:fyp_pawsenvy/presentation/widgets/profiles/pet/pet_profile_small.dart';
import 'package:go_router/go_router.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required this.user});
  final AppUser user;

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Stream<List<Pet>> ownedPets;
  late Stream<List<Pet>> likedPets;
  late DBService _db;

  @override
  Widget build(BuildContext context) {
    _db = Provider.of<DBService>(context, listen: false);

    ownedPets = _db.getPetsStreamByIDs(widget.user.ownedPets);
    likedPets = _db.getPetsStreamByIDs(widget.user.likedPets);

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
                              widget.user.avatar.isNotEmpty
                                  ? NetworkImage(widget.user.avatar)
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
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [                                  Text(
                                    widget.user.name.isNotEmpty
                                        ? capitalizeFirst(widget.user.name)
                                        : 'No name given :(',
                                    style: AppTextStyles.headingMedium,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            widget.user.userRole == UserRole.vet
                                                ? LineIcons.stethoscope
                                                : LineIcons.paw,
                                            size: 18,
                                            color: AppColorStyles.black,
                                          ),
                                          const SizedBox(width: 2),                                          Text(
                                            widget.user.userRole == UserRole.vet
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
                                            future:
                                                _getLocationNameFromGeoPoint(
                                                  widget.user.location,
                                                ),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Text(
                                                  'Fetching location...',
                                                  style:
                                                      AppTextStyles.bodySmall,
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                  'Error fetching location',
                                                  style:
                                                      AppTextStyles.bodySmall,
                                                );
                                              } else {
                                                return Text(
                                                  snapshot.data ??
                                                      'Unknown Location',
                                                  style:
                                                      AppTextStyles.bodySmall,
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
                      ),

                      const SizedBox(height: 20),

                      // ###################### Attributes
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
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
                                '${widget.user.ownedPets.length} Pets',
                              ),
                              _buildAttributeItem(
                                context,
                                LineIcons.heart,
                                '${widget.user.likedPets.length} Liked',
                              ),
                              _buildAttributeItem(
                                context,
                                LineIcons.calendar,
                                '${DateTime.now().year - widget.user.dob.year} years',
                              ),
                              if (widget.user.userRole == UserRole.vet &&
                                  widget.user.vetProfile != null)
                                _buildAttributeItem(
                                  context,
                                  LineIcons.stethoscope,
                                  'Verified',
                                ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('About', style: AppTextStyles.headingMedium),
                            const SizedBox(height: 4),                            Text(
                              widget.user.bio.isNotEmpty
                                  ? capitalizeFirst(widget.user.bio)
                                  : 'No bio available',
                              style: AppTextStyles.bodyBase,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Veterinary Profile Section (only for vets)
                      if (widget.user.userRole == UserRole.vet && widget.user.vetProfile != null)
                        _buildVetProfileSection(),

                      const SizedBox(height: 24),                      // Owned Pets Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Owned Pets',
                          style: AppTextStyles.headingMedium,
                        ),
                      ),
                      StreamBuilder<List<Pet>>(
                        stream: ownedPets,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError ||
                              !snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text('No pets found');
                          }
                          return SizedBox(
                            height: 220,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final pet = snapshot.data![index];
                                return GestureDetector(
                                  onTap: () {
                                    // Navigate to PetProfileScreen using GoRouter
                                    // Pass the pet object as an extra argument
                                    GoRouter.of(
                                      context,
                                    ).push(Routes.petProfile, extra: pet);
                                  },
                                  child: PetProfileSmall(pet: pet),
                                );
                              },
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 6),                      // Liked Pets Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Liked Pets',
                          style: AppTextStyles.headingMedium,
                        ),
                      ),
                      StreamBuilder<List<Pet>>(
                        stream: likedPets,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError ||
                              !snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: const Text('No pets found'));
                          }
                          return SizedBox(
                            height: 220,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final pet = snapshot.data![index];
                                return GestureDetector(
                                  onTap: () {
                                    // Navigate to PetProfileScreen using GoRouter
                                    // Pass the pet object as an extra argument
                                    GoRouter.of(
                                      context,
                                    ).push(Routes.petProfile, extra: pet);
                                  },
                                  child: PetProfileSmall(pet: pet),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),

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

  Widget _buildVetProfileSection() {
    final vetProfile = widget.user.vetProfile!;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Veterinary Information', style: AppTextStyles.headingMedium),
          const SizedBox(height: 16),
          
          // Clinic Information Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColorStyles.lightGrey.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Clinic Name
                Row(
                  children: [
                    Icon(
                      LineIcons.hospital,
                      size: 20,
                      color: AppColorStyles.purple,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        capitalizeFirst(vetProfile.clinicName),
                        style: AppTextStyles.bodyBase.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // License Number
                Row(
                  children: [
                    Icon(
                      LineIcons.certificate,
                      size: 20,
                      color: AppColorStyles.purple,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'License Number',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColorStyles.grey,
                            ),
                          ),
                          Text(
                            vetProfile.licenseNumber,
                            style: AppTextStyles.bodyBase,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Experience
                Row(
                  children: [
                    Icon(
                      LineIcons.clock,
                      size: 20,
                      color: AppColorStyles.purple,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${vetProfile.experience} years of experience',
                      style: AppTextStyles.bodyBase,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Specializations
          if (vetProfile.specializations.isNotEmpty) ...[
            Text('Specializations', style: AppTextStyles.headingSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: vetProfile.specializations.map((specialization) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColorStyles.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColorStyles.purple.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    capitalizeFirst(specialization.name),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColorStyles.purple,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          
          // Services
          if (vetProfile.services.isNotEmpty) ...[
            Text('Services Offered', style: AppTextStyles.headingSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: vetProfile.services.map((service) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColorStyles.pastelGreen.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColorStyles.pastelGreen,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getServiceIcon(service),
                        size: 16,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatServiceName(service.name),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          
          // Operating Hours
          if (vetProfile.operatingHours.isNotEmpty) ...[
            Text('Operating Hours', style: AppTextStyles.headingSmall),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: _buildOperatingHoursList(vetProfile.operatingHours),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  List<Widget> _buildOperatingHoursList(Map<Weekday, OperatingHours> operatingHours) {
    final List<Widget> hoursList = [];
    
    for (final entry in operatingHours.entries) {
      final weekday = entry.key;
      final hours = entry.value;
      
      hoursList.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getDayName(weekday),
                style: AppTextStyles.bodyBase.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                hours.isClosed 
                    ? 'Closed'
                    : '${hours.open!} - ${hours.close!}',
                style: AppTextStyles.bodyBase.copyWith(
                  color: hours.isClosed ? AppColorStyles.grey : AppColorStyles.black,
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    return hoursList;
  }
  
  String _getDayName(Weekday weekday) {
    switch (weekday) {
      case Weekday.mon:
        return 'Monday';
      case Weekday.tue:
        return 'Tuesday';
      case Weekday.wed:
        return 'Wednesday';
      case Weekday.thu:
        return 'Thursday';
      case Weekday.fri:
        return 'Friday';
      case Weekday.sat:
        return 'Saturday';
      case Weekday.sun:
        return 'Sunday';
    }
  }
  
  IconData _getServiceIcon(Service service) {
    switch (service) {
      case Service.petSitting:
        return LineIcons.home;
      case Service.petWalking:
        return LineIcons.walking;
      case Service.petGrooming:
        return LineIcons.cut;
      case Service.behaviourTraining:
        return LineIcons.graduationCap;
    }
  }
  
  String _formatServiceName(String serviceName) {
    switch (serviceName) {
      case 'petSitting':
        return 'Pet Sitting';
      case 'petWalking':
        return 'Pet Walking';
      case 'petGrooming':
        return 'Pet Grooming';
      case 'behaviourTraining':
        return 'Behaviour Training';
      default:
        return capitalizeFirst(serviceName);
    }
  }
}
