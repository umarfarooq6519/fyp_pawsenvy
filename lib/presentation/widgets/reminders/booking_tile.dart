import 'package:flutter/material.dart';
import '../../../core/theme/color.styles.dart';
import '../../../core/theme/text.styles.dart';
import '../../../core/utils/datetime.util.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/booking.dart';

class BookingTile extends StatelessWidget {
  final Booking booking;
  const BookingTile({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
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
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage(booking.petAvatar),
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(width: 6),
                    Text(booking.petName, style: AppTextStyles.bodySmall),
                  ],
                ),
                Text(
                  DateTimeUtils.formatTime12Hour(booking.time),
                  style: AppTextStyles.bodyExtraSmall.copyWith(
                    color: AppColorStyles.lightGrey,
                  ),
                ),
                // Vet name and avatar (inverted)
                Row(
                  children: [
                    Text(
                      overflow: TextOverflow.ellipsis,
                      booking.vetName,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 6),
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage(booking.vetAvatar),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
