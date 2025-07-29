import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/reminder.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/utils/datetime.util.dart';

class ReminderTile extends StatelessWidget {
  final Reminder reminder;

  const ReminderTile({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    return Text('Reminder tile')
  }
}
