import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:flutter/foundation.dart';
import 'package:fyp_pawsenvy/core/models/pet.dart';
import 'package:fyp_pawsenvy/core/models/reminder.dart';
import 'package:fyp_pawsenvy/core/models/booking.dart';
import 'package:fyp_pawsenvy/core/models/vet_profile.dart';
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
  Stream<AppUser> getSingleUserStream(String uID) {
    return users.doc(uID).snapshots().map((doc) => AppUser.fromFirestore(doc));
  }

  Future<AppUser?> getSingleUser(String uID) async {
    final doc = await users.doc(uID).get();
    if (doc.exists) {
      return AppUser.fromFirestore(doc);
    }
    return null;
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

  // ################### Pets ###################

  // Real-time stream of a pet's document
  Stream<Pet> getSinglePetStream(String pID) {
    return pets.doc(pID).snapshots().map((doc) => Pet.fromFirestore(doc));
  }

  // Stream of list of all pets in DB
  Stream<List<Pet>> getAllPetsStream() {
    return pets.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => Pet.fromFirestore(doc)).toList(),
    );
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

  Stream<List<Pet>> getPartnerFinderListing({
    required String species,
    required String gender,
  }) {
    Query query = pets;

    if (species.isNotEmpty) {
      query = query.where('species', isEqualTo: species);
    }

    if (gender.isNotEmpty) {
      query = query.where('gender', isEqualTo: gender);
    }

    return query.snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => Pet.fromFirestore(doc)).toList(),
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

  // ################### Reminders ###################

  // Save a reminder to DB
  Future<void> createReminder({
    required String uid,
    required String title,
    required String description,
    required DateTime dueDate,
    ReminderStatus status = ReminderStatus.pending,
  }) async {
    final id = uuid.v4();
    final reminder = Reminder(
      id: id,
      uID: uid,
      title: title,
      description: description,
      due: Timestamp.fromDate(dueDate),
      status: status,
      createdAt: Timestamp.now(),
    );

    await reminders.doc(id).set(reminder.toMap());
  }

  // Get stream of user reminders for date
  Stream<List<Reminder>> getRemindersForDate({
    required String uid,
    required DateTime date,
  }) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    return reminders
        .where('uID', isEqualTo: uid)
        .where('due', isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart))
        .where('due', isLessThan: Timestamp.fromDate(dayEnd))
        .orderBy('due')
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Reminder.fromFirestore).toList());
  }

  // Update status of a reminder
  Future<void> updateReminderStatus({
    required String reminderId,
    required ReminderStatus newStatus,
  }) async {
    await reminders.doc(reminderId).update({
      'status': reminderStatusToString(newStatus),
    });
  }

  // Delete a reminder
  Future<void> deleteReminder(String reminderId) async {
    await reminders.doc(reminderId).delete();
  }

  // ################### Vets ###################

  // Get all veterinarians
  Stream<List<AppUser>> getAllVetsStream() {
    return users
        .where('userType', isEqualTo: 'vet')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => AppUser.fromFirestore(doc))
                  .where(
                    (user) => user.vetProfile != null,
                  ) // Ensure they have a vet profile
                  .toList(),
        );
  }

  // Get a single vet by ID
  Future<AppUser?> getVetById(String vetId) async {
    try {
      final doc = await users.doc(vetId).get();
      if (doc.exists) {
        final user = AppUser.fromFirestore(doc);
        return user.userRole == UserRole.vet ? user : null;
      }
      return null;
    } catch (e) {
      if (kDebugMode) print('Error getting vet: $e');
      return null;
    }
  }

  // ################### Bookings ###################

  // Create a new booking request
  Future<String> createBooking({
    required String petID,
    required String vetID,
    required DateTime dateTime,
    required int duration,
  }) async {
    try {
      final bookingId = uuid.v4();
      final booking = Booking(
        petID: petID,
        vetID: vetID,
        dateTime: Timestamp.fromDate(dateTime),
        duration: duration,
        status: BookingStatus.pending,
      );

      await bookings.doc(bookingId).set(booking.toMap());

      if (kDebugMode) print('Booking created with ID: $bookingId');
      return bookingId;
    } catch (e) {
      if (kDebugMode) print('Error creating booking: $e');
      throw Exception('Failed to create booking: $e');
    }
  }

  // Get bookings for a specific vet
  Stream<List<Booking>> getVetBookings(String vetID) {
    return bookings
        .where('vetID', isEqualTo: vetID)
        .orderBy('dateTime')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => Booking.fromMap(
                      doc.data() as Map<String, dynamic>,
                      id: doc.id,
                    ),
                  )
                  .toList(),
        );
  }

  // Get bookings for a specific pet
  Stream<List<Booking>> getPetBookings(String petID) {
    return bookings
        .where('petID', isEqualTo: petID)
        .orderBy('dateTime')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => Booking.fromMap(
                      doc.data() as Map<String, dynamic>,
                      id: doc.id,
                    ),
                  )
                  .toList(),
        );
  }

  // Get bookings by status for a vet
  Stream<List<Booking>> getVetBookingsByStatus(
    String vetID,
    BookingStatus status,
  ) {
    return bookings
        .where('vetID', isEqualTo: vetID)
        .where('status', isEqualTo: _bookingStatusToString(status))
        .orderBy('dateTime')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => Booking.fromMap(
                      doc.data() as Map<String, dynamic>,
                      id: doc.id,
                    ),
                  )
                  .toList(),
        );
  }

  // Get bookings for a specific vet on a specific date
  Stream<List<Booking>> getVetBookingsForDate({
    required String vetID,
    required DateTime date,
  }) {
    final dayStart = DateTime(date.year, date.month, date.day);
    final dayEnd = dayStart.add(const Duration(days: 1));

    return bookings
        .where('vetID', isEqualTo: vetID)
        .where('dateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(dayStart))
        .where('dateTime', isLessThan: Timestamp.fromDate(dayEnd))
        .orderBy('dateTime')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => Booking.fromMap(
                      doc.data() as Map<String, dynamic>,
                      id: doc.id,
                    ),
                  )
                  .toList(),
        );
  }

  // Update booking status (vet accepts/declines)
  Future<void> updateBookingStatus(
    String bookingId,
    BookingStatus newStatus,
  ) async {
    try {
      await bookings.doc(bookingId).update({
        'status': _bookingStatusToString(newStatus),
      });

      if (kDebugMode) {
        print('Booking $bookingId status updated to ${newStatus.name}');
      }
    } catch (e) {
      if (kDebugMode) print('Error updating booking status: $e');
      throw Exception('Failed to update booking status: $e');
    }
  }

  // Check if vet is available for a specific slot
  Future<bool> isVetAvailable({
    required String vetID,
    required DateTime requestedDateTime,
    required int requestedDuration,
  }) async {
    try {
      // Get vet profile to check operating hours
      final AppUser? vet = await getSingleUser(vetID);
      if (vet?.vetProfile == null) return false;

      // Check if requested time falls within operating hours
      if (!_isWithinOperatingHours(vet!.vetProfile!, requestedDateTime)) {
        return false;
      }

      // Check for conflicts with existing accepted bookings
      final conflictingBookings =
          await bookings
              .where('vetID', isEqualTo: vetID)
              .where('status', isEqualTo: 'accepted')
              .get();

      final requestedStart = requestedDateTime;
      final requestedEnd = requestedDateTime.add(
        Duration(minutes: requestedDuration),
      );
      for (final doc in conflictingBookings.docs) {
        final existingBooking = Booking.fromMap(
          doc.data() as Map<String, dynamic>,
          id: doc.id,
        );
        final existingStart = existingBooking.dateTime.toDate();
        final existingEnd = existingStart.add(
          Duration(minutes: existingBooking.duration),
        );

        // Check if slots overlap
        if (requestedStart.isBefore(existingEnd) &&
            requestedEnd.isAfter(existingStart)) {
          return false; // Conflict found
        }
      }

      return true; // No conflicts
    } catch (e) {
      if (kDebugMode) print('Error checking vet availability: $e');
      return false;
    }
  }

  // Get available time slots for a vet on a specific date
  Future<List<DateTime>> getAvailableSlots({
    required String vetID,
    required DateTime date,
    required int slotDuration,
  }) async {
    try {
      final AppUser? vet = await getSingleUser(vetID);
      if (vet?.vetProfile == null) return [];

      final operatingHours = vet!.vetProfile!.operatingHours;

      // Get weekday from date
      final weekday = _getWeekdayFromDateTime(date);
      final dayHours = operatingHours[weekday];

      if (dayHours == null || dayHours.isClosed) {
        return []; // Vet is closed on this day
      }

      // Generate possible slots using minutes
      final startMinutes = dayHours.openMinutes!;
      final endMinutes = dayHours.closeMinutes!;

      final availableSlots = <DateTime>[];

      // Generate slots in 30-minute intervals
      for (
        int minutes = startMinutes;
        minutes + slotDuration <= endMinutes;
        minutes += 30
      ) {
        final slotHour = minutes ~/ 60;
        final slotMinute = minutes % 60;

        final currentSlot = DateTime(
          date.year,
          date.month,
          date.day,
          slotHour,
          slotMinute,
        );

        final isAvailable = await isVetAvailable(
          vetID: vetID,
          requestedDateTime: currentSlot,
          requestedDuration: slotDuration,
        );

        if (isAvailable) {
          availableSlots.add(currentSlot);
        }
      }
      return availableSlots;
    } catch (e) {
      if (kDebugMode) print('Error getting available slots: $e');
      return [];
    }
  }

  // Helper methods for booking logic
  bool _isWithinOperatingHours(
    VetProfile vetProfile,
    DateTime requestedDateTime,
  ) {
    final weekday = _getWeekdayFromDateTime(requestedDateTime);
    final operatingHours = vetProfile.operatingHours[weekday];

    if (operatingHours == null || operatingHours.isClosed) {
      return false; // Vet is closed on this day
    }

    final requestedMinutes =
        requestedDateTime.hour * 60 + requestedDateTime.minute;
    return operatingHours.isWithinHours(requestedMinutes);
  }

  Weekday _getWeekdayFromDateTime(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return Weekday.mon;
      case DateTime.tuesday:
        return Weekday.tue;
      case DateTime.wednesday:
        return Weekday.wed;
      case DateTime.thursday:
        return Weekday.thu;
      case DateTime.friday:
        return Weekday.fri;
      case DateTime.saturday:
        return Weekday.sat;
      case DateTime.sunday:
        return Weekday.sun;
      default:
        return Weekday.mon;
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
}
