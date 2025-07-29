import 'package:cloud_firestore/cloud_firestore.dart';

enum ReminderStatus { pending, completed, missed }

class Reminder {
  final String id;
  final String uID;
  final String title;
  final String description;
  final Timestamp due;
  final ReminderStatus status;
  final Timestamp createdAt;

  Reminder({
    required this.id,
    required this.uID,
    required this.title,
    required this.due,
    required this.status,
    required this.description,
    required this.createdAt,
  });

  factory Reminder.fromFirestore(DocumentSnapshot reminder) {
    final data = reminder.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    return Reminder(
      id: reminder.id,
      uID: data['uID'] ?? '',
      title: data['title'] ?? '',
      due: data['due'] ?? Timestamp.now(),
      status: reminderStatusFromString(data['status'] ?? 'pending'),
      description: data['description'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uID': uID,
      'title': title,
      'due': due,
      'status': reminderStatusToString(status),
      'description': description,
      'createdAt': createdAt,
    };
  }
}

String reminderStatusToString(ReminderStatus status) {
  switch (status) {
    case ReminderStatus.pending:
      return 'pending';
    case ReminderStatus.completed:
      return 'completed';
    case ReminderStatus.missed:
      return 'missed';
  }
}

ReminderStatus reminderStatusFromString(String status) {
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
    "uID": "user123",
    "title": "Walk the dog",
    "description": "Bring water for the walk",
    "due": Timestamp, // Firestore Timestamp
    "status": "pending" | "completed" | "missed",
    "createdAt": Timestamp
  }
  
*/
