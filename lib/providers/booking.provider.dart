import 'package:flutter/foundation.dart';
import 'package:fyp_pawsenvy/core/models/booking.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';

class BookingProvider with ChangeNotifier {
  final DBService _dbService = DBService();

  List<Booking> _vetBookings = [];
  List<Booking> _petBookings = [];
  List<DateTime> _availableSlots = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Booking> get vetBookings => _vetBookings;
  List<Booking> get petBookings => _petBookings;
  List<DateTime> get availableSlots => _availableSlots;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Create a new booking request
  Future<String?> createBooking({
    required String petID,
    required String vetID,
    required DateTime dateTime,
    required int duration,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Check if vet is available first
      final isAvailable = await _dbService.isVetAvailable(
        vetID: vetID,
        requestedDateTime: dateTime,
        requestedDuration: duration,
      );

      if (!isAvailable) {
        _setError('Vet is not available at the requested time');
        return null;
      }

      final bookingId = await _dbService.createBooking(
        petID: petID,
        vetID: vetID,
        dateTime: dateTime,
        duration: duration,
      );

      return bookingId;
    } catch (e) {
      _setError('Failed to create booking: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // Accept a booking (for vets)
  Future<bool> acceptBooking(String bookingId) async {
    try {
      _setLoading(true);
      _clearError();

      await _dbService.updateBookingStatus(bookingId, BookingStatus.accepted);
      return true;
    } catch (e) {
      _setError('Failed to accept booking: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Decline a booking (for vets)
  Future<bool> declineBooking(String bookingId) async {
    try {
      _setLoading(true);
      _clearError();

      await _dbService.updateBookingStatus(bookingId, BookingStatus.declined);
      return true;
    } catch (e) {
      _setError('Failed to decline booking: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get available slots for a vet on a specific date
  Future<void> fetchAvailableSlots({
    required String vetID,
    required DateTime date,
    int slotDuration = 30,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final slots = await _dbService.getAvailableSlots(
        vetID: vetID,
        date: date,
        slotDuration: slotDuration,
      );

      _availableSlots = slots;
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch available slots: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Listen to vet bookings
  void listenToVetBookings(String vetID) {
    _dbService
        .getVetBookings(vetID)
        .listen(
          (bookings) {
            _vetBookings = bookings;
            notifyListeners();
          },
          onError: (error) {
            _setError('Error listening to vet bookings: $error');
          },
        );
  }

  // Listen to pet bookings
  void listenToPetBookings(String petID) {
    _dbService
        .getPetBookings(petID)
        .listen(
          (bookings) {
            _petBookings = bookings;
            notifyListeners();
          },
          onError: (error) {
            _setError('Error listening to pet bookings: $error');
          },
        );
  }

  // Get pending bookings for a vet
  void listenToPendingVetBookings(String vetID) {
    _dbService
        .getVetBookingsByStatus(vetID, BookingStatus.pending)
        .listen(
          (bookings) {
            _vetBookings = bookings;
            notifyListeners();
          },
          onError: (error) {
            _setError('Error listening to pending bookings: $error');
          },
        );
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
