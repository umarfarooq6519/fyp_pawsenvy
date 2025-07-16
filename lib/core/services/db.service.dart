import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fyp_pawsenvy/core/models/booking.dart';

class DBService {
  // get all bookings
  final CollectionReference bookings = FirebaseFirestore.instance.collection(
    'bookings',
  );

  // add a booking
  Future<void> addBooking(Booking booking) async {
    try {
      final result = await bookings.add(booking.toMap());
      if (kDebugMode) print('Booking added ${result.id}');
    } catch (e) {
      throw Exception('Failed to add booking: $e');
    }
  }
}
