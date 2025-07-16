import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ReminderStatus { pending, completed, missed }

class Reminder {
  final String title;
  final Timestamp time;
  final IconData icon;
  final ReminderStatus status;
  final String notes;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Reminder({
    required this.title,
    required this.time,
    required this.icon,
    required this.status,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reminder.fromMap(Map<String, dynamic> data) {
    return Reminder(
      title: data['title'] ?? '',
      time: data['time'] ?? Timestamp.now(),
      icon: IconData(data['icon'] ?? 0, fontFamily: 'MaterialIcons'),
      status: _reminderStatusFromString(data['status'] ?? 'pending'),
      notes: data['notes'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'time': time,
      'icon': icon.codePoint,
      'status': _reminderStatusToString(status),
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

String _reminderStatusToString(ReminderStatus status) {
  switch (status) {
    case ReminderStatus.pending:
      return 'pending';
    case ReminderStatus.completed:
      return 'completed';
    case ReminderStatus.missed:
      return 'missed';
  }
}

ReminderStatus _reminderStatusFromString(String status) {
  switch (status) {
    case 'pending':
      return ReminderStatus.pending;
    case 'completed':
      return ReminderStatus.completed;
    case 'missed':
      return ReminderStatus.missed;
    default:
      return ReminderStatus.pending;
  }
}

// ##################### return format #####################
/*

  {
    "title": "Walk the dog",
    "time": Timestamp, // Firestore Timestamp
    "icon": 0xe567, // codePoint for IconData
    "status": "pending" | "completed" | "missed",
    "notes": "Bring water for the walk",
    "createdAt": Timestamp,
    "updatedAt": Timestamp
  }
  
*/
