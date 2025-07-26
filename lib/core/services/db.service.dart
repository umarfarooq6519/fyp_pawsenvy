import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  var uuid = Uuid();

  // ################### User ###################

  // Real-time stream of a user's document
  Stream<AppUser> getUserStream(String uID) {
    return users.doc(uID).snapshots().map((doc) => AppUser.fromFirestore(doc));
  }

  // Real-time stream of a pet's document
  Stream<Pet> getPetStream(String pID) {
    return pets.doc(pID).snapshots().map((doc) => Pet.fromFirestore(doc));
  }

  Stream<List<Pet>> getAdoptionPetsStream() {
    return pets
        .where('status', isEqualTo: 'adopted')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Pet.fromFirestore(doc)).toList(),
        );
  }

  Stream<List<Pet>> getLostFoundPetsStream() {
    return pets
        .where('status', isEqualTo: 'lost')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Pet.fromFirestore(doc)).toList(),
        );
  }

  Stream<List<Pet>> getPetsStreamByIDs(List<String> petIds) {
    if (petIds.isEmpty) return Stream.value([]);

    return pets
        .where(FieldPath.documentId, whereIn: petIds)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Pet.fromFirestore(doc)).toList(),
        );
  }

  Future<bool> updatePetFields(
    BuildContext context,
    String pID,
    Map<String, dynamic> fields,
  ) async {
    try {
      await pets.doc(pID).update(fields);
      return true;
    } catch (e) {
      throw Exception('updatePetFields() failed: $e');
    }
  }

  // Update multiple user doc fields
  Future<bool> updateUserFields(
    BuildContext context,
    String uID,
    Map<String, dynamic> fields,
  ) async {
    try {
      await users.doc(uID).update(fields);
      return true;
    } catch (e) {
      throw Exception('updateUserFields() failed: $e');
    }
  }

  Future<void> addUserToDB(AppUser appUser, String uID) async {
    try {
      // add user to db with docID of auth user id
      await users.doc(uID).set(appUser.toMap());

      if (kDebugMode) print('User added with docID $uID');
    } catch (e) {
      if (kDebugMode) print('addUserToDB() failed: $e');
      throw Exception('addUserToDB() failed: $e');
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

  Future<AppUser?> getUserProfile(String uID) async {
    try {
      DocumentSnapshot doc = await users.doc(uID).get();
      if (doc.exists) {
        return AppUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Error fetching user profile: $e");
      return null;
    }
  }

  // ################### Pets ###################

  Future<void> uploadPetToDB(Pet pet, String uID) async {
    try {
      final DocumentReference doc = await pets.add(pet.toMap());

      // Update that same doc to include its ID
      await pets.doc(doc.id).update({'pID': doc.id});

      savePetToUserDoc(uID, 'ownedPets', doc.id);

      if (kDebugMode) print('Pet added with docId ${doc.id}');
    } catch (e) {
      throw Exception('addPet() failed: $e');
    }
  }

  Future<DocumentReference?> savePetToUserDoc(
    String uID,
    String field,
    String value,
  ) async {
    try {
      final DocumentReference userRef = users.doc(uID);
      await userRef.update({
        field: FieldValue.arrayUnion([value]),
      });

      return userRef;
    } catch (e) {
      throw Exception('Error updating user field: $e');
    }
  }

  Future<DocumentReference?> removePetFromUserDoc(
    String uID,
    String field,
    String value,
  ) async {
    try {
      final DocumentReference userRef = users.doc(uID);
      await userRef.update({
        field: FieldValue.arrayRemove([value]),
      });

      return userRef;
    } catch (e) {
      throw Exception('Error updating user field: $e');
    }
  }

  Future<bool> checkIfUserHasPet(
    String userId,
    String petId,
    String field,
  ) async {
    try {
      final userDoc = await users.doc(userId).get();
      if (userDoc.exists) {
        final List<dynamic> petIds =
            (userDoc.data() as Map<String, dynamic>?)![field] ?? [];
        return petIds.contains(petId);
      }
      return false;
    } catch (e) {
      debugPrint('Error checking petID: $e');
      return false;
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

  Future<AppUser?> fetchVetByID(String vetId) async {
    try {
      final doc = await users.doc(vetId).get();
      if (doc.exists) {
        return AppUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      if (kDebugMode) print('fetchVetByID() failed: $e');
      return null;
    }
  }
}
