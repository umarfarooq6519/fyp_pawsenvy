import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/reminder.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';

class ReminderTile extends StatelessWidget {
  final Reminder reminder;

  const ReminderTile({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon
        Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(right: 16),
          child: Icon(reminder.icon, color: reminder.iconColor, size: 20),
        ),

        // Title
        Expanded(
          child: Text(
            reminder.title,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w400,
              decoration:
                  reminder.isCompleted ? TextDecoration.lineThrough : null,
              color:
                  reminder.isCompleted
                      ? AppColorStyles.lightGrey
                      : AppColorStyles.black,
            ),
          ),
        ),

        // Time
        Text(
          reminder.time,
          style: AppTextStyles.bodyExtraSmall.copyWith(
            color: AppColorStyles.lightGrey,
          ),
        ),
      ],
    );
  }
}
