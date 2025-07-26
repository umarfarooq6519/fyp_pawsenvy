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

  // Real-time stream of the user's document
  Stream<AppUser> getUserStream(String uID) {
    return users.doc(uID).snapshots().map((doc) => AppUser.fromFirestore(doc));
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

  Future<bool> isUserProfileComplete(String uID) async {
    try {
      final DocumentSnapshot doc;
      doc = await users.doc(uID).get();

      if (!doc.exists) return false;

      AppUser user = AppUser.fromFirestore(doc);

      // Check if basic required fields are filled
      return user.name.isNotEmpty &&
          user.phone.isNotEmpty &&
          user.bio.isNotEmpty &&
          user.phone.isNotEmpty;
    } catch (e) {
      if (kDebugMode) print("Error checking profile completeness: $e");
      return false;
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

  Future<bool> togglePetLike({
    required String userId,
    required String petId,
  }) async {
    try {
      // Reuse existing getUserProfile function
      AppUser? user = await getUserProfile(userId);
      if (user == null) {
        throw Exception('User not found');
      }

      List<String> updatedLikedPets = List.from(user.likedPets);
      bool isNowLiked;

      if (user.likedPets.contains(petId)) {
        // Pet is currently liked, so unlike it
        updatedLikedPets.remove(petId);
        isNowLiked = false;
        if (kDebugMode) {
          print('Pet $petId removed from likedPets for user $userId');
        }
      } else {
        // Pet is not liked, so like it
        updatedLikedPets.add(petId);
        isNowLiked = true;
        if (kDebugMode) print('Pet $petId added to likedPets for user $userId');
      }

      await users.doc(userId).update({'likedPets': updatedLikedPets});
      return isNowLiked;
    } catch (e) {
      if (kDebugMode) print('togglePetLike() failed: $e');
      throw Exception('togglePetLike() failed: $e');
    }
  }

  Future<void> addPetToUserLikedPets({
    required String userId,
    required String petId,
  }) async {
    try {
      // Reuse existing getUserProfile function
      AppUser? user = await getUserProfile(userId);
      if (user == null) {
        throw Exception('User not found');
      }

      // Check if pet is already in liked pets
      if (!user.likedPets.contains(petId)) {
        List<String> updatedLikedPets = List.from(user.likedPets)..add(petId);
        await users.doc(userId).update({'likedPets': updatedLikedPets});
        if (kDebugMode) print('Pet $petId added to likedPets for user $userId');
      } else {
        if (kDebugMode) {
          print('Pet $petId already in likedPets for user $userId');
        }
      }
    } catch (e) {
      if (kDebugMode) print('addPetToUserLikedPets() failed: $e');
      throw Exception('addPetToUserLikedPets() failed: $e');
    }
  }

  Future<void> removePetFromUserLikedPets({
    required String userId,
    required String petId,
  }) async {
    try {
      // Reuse existing getUserProfile function
      AppUser? user = await getUserProfile(userId);
      if (user == null) {
        throw Exception('User not found');
      }

      if (user.likedPets.contains(petId)) {
        List<String> updatedLikedPets = List.from(user.likedPets)
          ..remove(petId);
        await users.doc(userId).update({'likedPets': updatedLikedPets});
        if (kDebugMode) {
          print('Pet $petId removed from likedPets for user $userId');
        }
      } else {
        if (kDebugMode) print('Pet $petId not in likedPets for user $userId');
      }
    } catch (e) {
      if (kDebugMode) print('removePetFromUserLikedPets() failed: $e');
      throw Exception('removePetFromUserLikedPets() failed: $e');
    }
  }

  Future<bool> isPetLikedByUser({
    required String userId,
    required String petId,
  }) async {
    try {
      AppUser? user = await getUserProfile(userId);
      return user?.likedPets.contains(petId) ?? false;
    } catch (e) {
      if (kDebugMode) print('isPetLikedByUser() failed: $e');
      return false;
    }
  }

  // ################### Pets ###################

  Future<void> addPetToDB(Pet pet) async {
    try {
      final DocumentReference doc;
      doc = await pets.add(pet.toMap());

      if (kDebugMode) print('Pet added with docId ${doc.id}');
    } catch (e) {
      throw Exception('addPet() failed: $e');
    }
  }

  Future<List<Pet>> fetchAllPets() async {
    try {
      final querySnapshot = await pets.get();
      return querySnapshot.docs
          .map((doc) => Pet.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('fetchAllPets() failed: $e');
    }
  }

  Future<List<Pet>> fetchUserOwnedPets(String userId) async {
    try {
      final querySnapshot =
          await pets.where('ownerId', isEqualTo: userId).get();
      return querySnapshot.docs
          .map((doc) => Pet.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('fetchUserOwnedPets() failed: $e');
    }
  }

  Future<Pet?> fetchPetByID(String petId) async {
    try {
      final doc = await pets.doc(petId).get();
      if (doc.exists) {
        return Pet.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      if (kDebugMode) print('fetchPetByID() failed: $e');
      return null;
    }
  }

  Future<List<Pet>> fetchUserLikedPets(String userId) async {
    try {
      AppUser? user = await getUserProfile(userId);
      if (user == null || user.likedPets.isEmpty) {
        return [];
      }

      List<Pet> likedPets = [];
      for (String petId in user.likedPets) {
        Pet? pet = await fetchPetByID(petId);
        if (pet != null) {
          likedPets.add(pet);
        }
      }
      return likedPets;
    } catch (e) {
      if (kDebugMode) print('fetchUserLikedPets() failed: $e');
      return [];
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
