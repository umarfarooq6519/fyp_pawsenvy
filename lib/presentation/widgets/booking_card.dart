import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/utils/date_time_utils.dart';
import '../../core/theme/app_theme.dart';

class BookingCard extends StatelessWidget {
  final String petName;
  final String petImage;
  final String vetName;
  final String vetImage;
  final String time;
  const BookingCard({
    super.key,
    required this.petName,
    required this.petImage,
    required this.vetName,
    required this.vetImage,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.sm + 1),
      decoration: BoxDecoration(
        gradient: AppColorStyles.profileGradient,
        borderRadius: BorderRadius.circular(AppBorderRadius.medium),
        border: Border.all(color: AppColorStyles.lightPurple),
        // boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 7)],
      ),
      child: Row(
        children: [
          // Pet avatar and name
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(petImage),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(width: AppSpacing.md),
              Text(
                petName,
                style: AppTextStyles.bodyBase.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ), // Spacer and time
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateTimeUtils.formatTime12Hour(time),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColorStyles.lightGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Vet name and avatar (inverted)
          Row(
            children: [
              Text(
                vetName,
                style: AppTextStyles.bodyBase.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              CircleAvatar(radius: 20, backgroundImage: AssetImage(vetImage)),
            ],
          ),
        ],
      ),
    );
  }
}
