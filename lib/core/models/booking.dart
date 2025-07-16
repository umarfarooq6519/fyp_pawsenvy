import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus { pending, confirmed, cancelled }

class Booking {
  final String petID;
  final String vetID;
  final Timestamp dateTime;
  final BookingStatus status;
  final int duration; // duration in minutes

  Booking({
    required this.petID,
    required this.vetID,
    required this.dateTime,
    required this.duration,
    required this.status,
  });

  factory Booking.fromMap(Map<String, dynamic> data) {
    return Booking(
      petID: data['petID'] ?? '',
      vetID: data['vetID'] ?? '',
      dateTime: data['dateTime'] ?? Timestamp.now(),
      duration: data['duration'] ?? 0,
      status: _bookingStatusFromString(data['status'] ?? 'pending'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'petID': petID,
      'vetID': vetID,
      'dateTime': dateTime,
      'duration': duration,
      'status': _bookingStatusToString(status),
    };
  }
}

String _bookingStatusToString(BookingStatus status) {
  switch (status) {
    case BookingStatus.pending:
      return 'pending';
    case BookingStatus.confirmed:
      return 'confirmed';
    case BookingStatus.cancelled:
      return 'cancelled';
  }
}

BookingStatus _bookingStatusFromString(String status) {
  switch (status) {
    case 'pending':
      return BookingStatus.pending;
    case 'confirmed':
      return BookingStatus.confirmed;
    case 'cancelled':
      return BookingStatus.cancelled;
    default:
      return BookingStatus.pending;
  }
}

// ##################### return format #####################
/*
  {
    "petID": "petId123",
    "vetID": "vetId123",
    "dateTime": Timestamp, // Firestore Timestamp
    "status": "pending" | "confirmed" | "cancelled"
    "duration": 30, // duration in minutes (int)
  }
*/
