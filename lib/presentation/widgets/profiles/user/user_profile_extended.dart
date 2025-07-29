import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/theme/theme.dart';
import 'package:fyp_pawsenvy/core/utils/text.util.dart';
import 'package:fyp_pawsenvy/providers/user.provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';

class UserProfileExtended extends StatefulWidget {
  final AppUser user;

  const UserProfileExtended({super.key, required this.user});

  @override
  State<UserProfileExtended> createState() => _UserProfileExtendedState();
}

class _UserProfileExtendedState extends State<UserProfileExtended> {
  late AppUser? currentUser;
  late String name;
  late String gender;
  late GeoPoint location;

  @override
  Widget build(BuildContext context) {
    currentUser = context.watch<UserProvider>().user;

    name = widget.user.name;
    gender = widget.user.gender.name;
    location = widget.user.location;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: AppColorStyles.lightPurple),
        gradient: AppColorStyles.profileGradient,
        borderRadius: BorderRadius.circular(AppBorderRadius.xLarge),
        boxShadow: [
          BoxShadow(color: AppColorStyles.lightPurple, blurRadius: 7),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage('assets/images/person1.png'),
                ),

                SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentUser!.name == name ? 'You' : name,
                      style: AppTextStyles.bodyBase.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      capitalizeFirst(gender),
                      style: AppTextStyles.bodyExtraSmall.copyWith(
                        color: AppColorStyles.lightGrey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            Chip(
              label: FutureBuilder<List<Placemark>>(
                future: placemarkFromCoordinates(
                  location.latitude,
                  location.longitude,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading...');
                  }
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const Text('Unknown');
                  }
                  final place = snapshot.data!.first;
                  final locationName = [
                    place.locality,
                  ].where((part) => part != null && part.isNotEmpty).join(', ');
                  return Text(
                    locationName.isNotEmpty ? locationName : 'Unknown',
                  );
                },
              ),
              backgroundColor: AppColorStyles.lightPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(width: 0),
              ),
              padding: EdgeInsets.all(0),
            ),
          ],
        ),
      ),
    );
  }
}
