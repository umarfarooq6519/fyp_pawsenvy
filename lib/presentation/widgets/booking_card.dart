import 'package:flutter/material.dart';
import '../../core/utils/colors.dart';
import '../../core/utils/text_styles.dart';

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

  String _formatTime(String time24) {
    try {
      final parts = time24.split(':');
      if (parts.length != 2) return time24;

      final hour = int.parse(parts[0]);
      final minute = parts[1];

      if (hour == 0) {
        return '12:$minute AM';
      } else if (hour < 12) {
        return '$hour:$minute AM';
      } else if (hour == 12) {
        return '12:$minute PM';
      } else {
        return '${hour - 12}:$minute PM';
      }
    } catch (e) {
      return time24;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        gradient: AppColors.profileGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.deepPurpleBorder),
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
              const SizedBox(width: 12),
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
                  _formatTime(time),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.lightGrey,
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
              const SizedBox(width: 12),
              CircleAvatar(radius: 20, backgroundImage: AssetImage(vetImage)),
            ],
          ),
        ],
      ),
    );
  }
}
