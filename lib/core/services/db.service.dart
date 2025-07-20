import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:flutter/foundation.dart';
import 'package:fyp_pawsenvy/core/models/booking.dart';
import 'package:fyp_pawsenvy/core/models/pet.dart';
import 'package:uuid/uuid.dart';

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
  );

  // final auth = AuthService();

  var uuid = Uuid();

  // ################### User ###################

  Future<void> addUserToFirestore(AppUser appUser) async {
    try {
      await users.doc(appUser.id).set(appUser.toMap());
      if (kDebugMode) print('User added with docID ${appUser.id}');
    } catch (e) {
      throw Exception('addUserToFirestore() failed: $e');
    }
  }

  Future<UserRole> getUserRole(String uID) async {
    try {
      DocumentSnapshot userDoc = await users.doc(uID).get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;

        // Use the mapping function from AppUser
        return AppUser.fromMap(uID, data).userRole;
      }
      return UserRole.undefined;
    } catch (e) {
      if (kDebugMode) print("Error fetching user role: $e");
      return UserRole.undefined;
    }
  }

  Future<void> setUserRole(String uID, UserRole role) async {
    try {
      await users.doc(uID).update({'userType': role.name});
      if (kDebugMode) print('User role updated for $uID to ${role.name}');
    } catch (e) {
      if (kDebugMode) print("Error setting user role: $e");
      throw Exception('setUserRole() failed: $e');
    }
  }

  Future<bool> isUserProfileComplete(String uID) async {
    try {
      DocumentSnapshot userDoc = await users.doc(uID).get();
      if (!userDoc.exists) {
        return false;
      }
      var data = userDoc.data() as Map<String, dynamic>;
      AppUser user = AppUser.fromMap(uID, data);

      // Check if basic required fields are filled
      bool hasBasicInfo =
          user.name.isNotEmpty && user.phone.isNotEmpty && user.bio.isNotEmpty;

      return hasBasicInfo;
    } catch (e) {
      if (kDebugMode) print("Error checking profile completeness: $e");
      return false;
    }
  }

  Future<AppUser?> getUserProfile(String uID) async {
    try {
      DocumentSnapshot userDoc = await users.doc(uID).get();
      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;
        return AppUser.fromMap(uID, data);
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Error fetching user profile: $e");
      return null;
    }
  }

  // ################### Pets ###################

  Future<void> addPet(Pet pet, String docId) async {
    // adding pet using Pet class and v4 uuid as docID

    try {
      await pets.doc(docId).set(pet.toMap());
      if (kDebugMode) print('Pet added with docId $docId');
    } catch (e) {
      throw Exception('addPet() failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllPets() async {
    try {
      final querySnapshot = await pets.get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('fetchAllPets() failed: $e');
    }
  }

  // ################### Bookings ###################

  Future<void> addBooking(Booking booking) async {
    try {
      final result = await bookings.add(booking.toMap());
      if (kDebugMode) print('Booking added ${result.id}');
    } catch (e) {
      throw Exception('addBooking() failed: $e');
    }
  }

  // ################### Vets ###################

  Future<Map<String, dynamic>?> fetchPetByID(String petId) async {
    final doc = await pets.doc(petId).get();
    return doc.exists ? doc.data() as Map<String, dynamic>? : null;
  }

  Future<Map<String, dynamic>?> fetchVetByID(String vetId) async {
    final doc = await users.doc(vetId).get();
    return doc.exists ? doc.data() as Map<String, dynamic>? : null;
  }
}
