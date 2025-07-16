import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/reminder.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/utils/datetime.util.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';

class ReminderTile extends StatelessWidget {
  final Reminder reminder;
  final DBService db = DBService();

  ReminderTile({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.only(right: 16),
          child: Icon(reminder.icon, color: AppColorStyles.purple, size: 20),
        ),
        Expanded(
          child: Text(
            reminder.title,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w400,
              decoration:
                  reminder.status == ReminderStatus.completed
                      ? TextDecoration.lineThrough
                      : null,
              color:
                  reminder.status == ReminderStatus.completed
                      ? AppColorStyles.lightGrey
                      : AppColorStyles.black,
            ),
          ),
        ),
        Text(
          DateTimeUtils.formatTime12Hour(reminder.time.toDate()),
          style: AppTextStyles.bodyExtraSmall.copyWith(
            color: AppColorStyles.lightGrey,
          ),
        ),
      ],
    );
  }
}
