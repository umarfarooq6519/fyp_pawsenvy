import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus { pending, accepted, declined }

class Booking {
  final String? bookingID; // Made optional for creation, set by Firestore
  final String petID;
  final String vetID;
  final Timestamp dateTime;
  final BookingStatus status;
  final int duration; // duration in minutes

  Booking({
    this.bookingID,
    required this.petID,
    required this.vetID,
    required this.dateTime,
    required this.duration,
    required this.status,
  });

  factory Booking.fromMap(Map<String, dynamic> data, {String? id}) {
    return Booking(
      bookingID: id ?? data['bookingID'],
      petID: data['petID'] ?? '',
      vetID: data['vetID'] ?? '',
      dateTime: data['dateTime'] ?? Timestamp.now(),
      duration: data['duration'] ?? 0,
      status: _bookingStatusFromString(data['status'] ?? 'pending'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (bookingID != null) 'bookingID': bookingID,
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
    case BookingStatus.accepted:
      return 'accepted';
    case BookingStatus.declined:
      return 'declined';
  }
}

BookingStatus _bookingStatusFromString(String status) {
  switch (status) {
    case 'pending':
      return BookingStatus.pending;
    case 'accepted':
      return BookingStatus.accepted;
    case 'declined':
      return BookingStatus.declined;
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
    "status": "pending" | "accepted" | "declined"
    "duration": 30, // duration in minutes (int)
  }
*/
