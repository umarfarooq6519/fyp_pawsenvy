import 'package:flutter/material.dart';
import '../../../core/theme/color.styles.dart';
import '../../../core/theme/text.styles.dart';

class BookingTile extends StatelessWidget {
  const BookingTile({super.key});

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
              borderRadius: BorderRadius.circular(12),
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
                      backgroundColor: Colors.transparent,
                    ),
                    SizedBox(width: 6),
                    Text('Pet Name', style: AppTextStyles.bodySmall),
                  ],
                ),
                Text(
                  'Time',
                  style: AppTextStyles.bodyExtraSmall.copyWith(
                    color: AppColorStyles.lightGrey,
                  ),
                ),
                // Vet name and avatar (inverted)
                Row(
                  children: [
                    Text(
                      'Vet Name',
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 6),
                    CircleAvatar(radius: 18),
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
