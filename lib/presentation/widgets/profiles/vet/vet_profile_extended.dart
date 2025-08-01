import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/theme/theme.dart';
import 'package:fyp_pawsenvy/core/utils/text.util.dart';

class VetProfileExtended extends StatefulWidget {
  final AppUser vet;

  const VetProfileExtended({super.key, required this.vet});

  @override
  State<VetProfileExtended> createState() => _VetProfileExtendedState();
}

class _VetProfileExtendedState extends State<VetProfileExtended> {
  late String name;
  late String clinic;
  late int experience;
  @override
  Widget build(BuildContext context) {
    final nameParts = widget.vet.name.split(' ');
    name =
        nameParts.length >= 2
            ? '${nameParts[0]} ${nameParts[1]}'
            : widget.vet.name;
    clinic = widget.vet.vetProfile!.clinicName;
    experience = widget.vet.vetProfile!.experience;

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
                  backgroundImage:
                      widget.vet.avatar.isNotEmpty
                          ? NetworkImage(widget.vet.avatar)
                          : AssetImage('assets/images/person1.png')
                              as ImageProvider,
                ),

                SizedBox(width: 10),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.bodyBase.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      capitalizeFirst(clinic),
                      style: AppTextStyles.bodyExtraSmall.copyWith(
                        color: AppColorStyles.lightGrey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            Chip(
              label: Text('${experience.toString()} years'),
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
