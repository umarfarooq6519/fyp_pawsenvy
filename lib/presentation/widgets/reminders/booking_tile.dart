import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/color.styles.dart';
import '../../../core/theme/text.styles.dart';
import '../../../core/utils/datetime.util.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/booking.dart';
import '../../../core/models/pet.dart';
import '../../../core/models/app_user.dart';
import '../../../core/services/db.service.dart';

class BookingTile extends StatelessWidget {
  final Booking booking;

  const BookingTile({super.key, required this.booking});
  @override  Widget build(BuildContext context) {
    final dbService = Provider.of<DBService>(context, listen: false);
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        dbService.fetchPetByID(booking.petID),
        dbService.fetchVetByID(booking.vetID),
      ]),
      builder: (context, snapshot) {        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final Pet? pet = snapshot.data?[0] as Pet?;
        final AppUser? vet = snapshot.data?[1] as AppUser?;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: AppColorStyles.profileGradient,
                  borderRadius: BorderRadius.circular(AppBorderRadius.medium),
                  border: Border.all(color: AppColorStyles.lightPurple),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Pet avatar and name
                    Row(
                      children: [                        CircleAvatar(
                          radius: 18,
                          backgroundImage:
                              pet != null && pet.avatar.isNotEmpty
                                  ? NetworkImage(pet.avatar)
                                  : null,
                          backgroundColor: Colors.transparent,
                        ),
                        SizedBox(width: 6),
                        Text(
                          pet != null
                              ? pet.name
                              : booking.petID,
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                    Text(
                      DateTimeUtils.formatTime12Hour(booking.dateTime.toDate()),
                      style: AppTextStyles.bodyExtraSmall.copyWith(
                        color: AppColorStyles.lightGrey,
                      ),
                    ),                    // Vet name and avatar (inverted)
                    Row(
                      children: [
                        Text(
                          vet != null
                              ? vet.name
                              : booking.vetID,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 6),
                        CircleAvatar(
                          radius: 18,
                          backgroundImage:
                              vet != null && vet.avatar.isNotEmpty
                                  ? NetworkImage(vet.avatar)
                                  : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
