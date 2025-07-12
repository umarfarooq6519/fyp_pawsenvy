import 'package:flutter/material.dart';

class ReminderItem {
  final String title;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool isCompleted;

  ReminderItem({
    required this.title,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.isCompleted,
  });
}
