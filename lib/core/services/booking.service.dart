import 'package:fyp_pawsenvy/core/models/booking.dart';
import 'package:fyp_pawsenvy/core/models/vet_profile.dart';

class BookingService {
  // Convert time slot to readable format
  static String formatTimeSlot(DateTime dateTime, int duration) {
    final startTime =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    final endTime = dateTime.add(Duration(minutes: duration));
    final endTimeStr =
        "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}";
    return "$startTime - $endTimeStr";
  }

  // Format date for display
  static String formatBookingDate(DateTime dateTime) {
    final weekdays = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final weekday = weekdays[dateTime.weekday - 1];
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = months[dateTime.month - 1];

    return "$weekday, $day $month";
  }

  // Get status color for booking status
  static String getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return '#FFA726'; // Orange
      case BookingStatus.accepted:
        return '#66BB6A'; // Green
      case BookingStatus.declined:
        return '#EF5350'; // Red
    }
  }

  // Get status display text
  static String getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.accepted:
        return 'Accepted';
      case BookingStatus.declined:
        return 'Declined';
    }
  }

  // Check if booking is in the past
  static bool isBookingExpired(DateTime bookingDateTime) {
    return bookingDateTime.isBefore(DateTime.now());
  }

  // Check if booking can be cancelled (e.g., 24 hours before)
  static bool canCancelBooking(DateTime bookingDateTime) {
    final now = DateTime.now();
    final timeDifference = bookingDateTime.difference(now);
    return timeDifference.inHours >= 24;
  }

  // Get time until booking
  static String getTimeUntilBooking(DateTime bookingDateTime) {
    final now = DateTime.now();
    final difference = bookingDateTime.difference(now);

    if (difference.isNegative) {
      return 'Past';
    }

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'}';
    } else {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'}';
    }
  }

  // Generate suggested time slots based on vet's schedule
  static List<String> generateSuggestedSlots(OperatingHours operatingHours) {
    if (operatingHours.open == null || operatingHours.close == null) {
      return []; // Vet is closed
    }

    final slots = <String>[];
    final openMinutes = _timeToMinutes(operatingHours.open!);
    final closeMinutes = _timeToMinutes(operatingHours.close!);

    // Generate 30-minute slots
    for (int minutes = openMinutes; minutes < closeMinutes; minutes += 30) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      slots.add(
        "${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}",
      );
    }

    return slots;
  }

  // Convert time string to minutes since midnight
  static int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  // Validate booking request
  static String? validateBookingRequest({
    required String petID,
    required String vetID,
    required DateTime dateTime,
    required int duration,
  }) {
    if (petID.isEmpty) return 'Pet ID is required';
    if (vetID.isEmpty) return 'Vet ID is required';
    if (duration <= 0) return 'Duration must be greater than 0';
    if (dateTime.isBefore(DateTime.now())) {
      return 'Cannot book appointments in the past';
    }

    // Check if booking is too far in the future (e.g., 3 months)
    final maxFutureDate = DateTime.now().add(const Duration(days: 90));
    if (dateTime.isAfter(maxFutureDate)) {
      return 'Cannot book appointments more than 3 months in advance';
    }

    return null; // Valid
  }

  // Get booking duration options
  static List<int> getBookingDurationOptions() {
    return [15, 30, 45, 60, 90, 120]; // Duration options in minutes
  }

  // Convert minutes to readable duration
  static String formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min${minutes == 1 ? '' : 's'}';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours hour${hours == 1 ? '' : 's'}';
      } else {
        return '$hours hour${hours == 1 ? '' : 's'} $remainingMinutes min${remainingMinutes == 1 ? '' : 's'}';
      }
    }
  }
}
