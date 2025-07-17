import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fyp_pawsenvy/core/models/booking.dart';
import 'package:fyp_pawsenvy/core/models/pet.dart';

class DBService {
  final CollectionReference users = FirebaseFirestore.instance.collection(
    'users',
  );
  final CollectionReference pets = FirebaseFirestore.instance.collection(
    'pets',
  );
  final CollectionReference bookings = FirebaseFirestore.instance.collection(
    'bookings',
  );
  final CollectionReference reminders = FirebaseFirestore.instance.collection(
    'reminders',
  );  Future<void> addPet(Pet pet) async {
    try {
      final result = await pets.add(pet.toMap());
      if (kDebugMode) print('Pet added ${result.id}');
    } catch (e) {
      throw Exception('addPet() failed: $e');
    }
  }

  Future<void> addBooking(Booking booking) async {
    try {
      final result = await bookings.add(booking.toMap());
      if (kDebugMode) print('Booking added ${result.id}');
    } catch (e) {
      throw Exception('addBooking() failed: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchPetByID(String petId) async {
    final doc = await pets.doc(petId).get();
    return doc.exists ? doc.data() as Map<String, dynamic>? : null;
  }

  Future<Map<String, dynamic>?> fetchVetByID(String vetId) async {
    final doc = await users.doc(vetId).get();
    return doc.exists ? doc.data() as Map<String, dynamic>? : null;
  }
}
