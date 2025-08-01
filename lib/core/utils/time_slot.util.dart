import 'package:fyp_pawsenvy/core/models/vet_profile.dart';

class TimeSlotUtil {
  // Convert time string (HH:MM) to minutes since midnight
  static int timeToMinutes(String time) {
    final parts = time.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    return hours * 60 + minutes;
  }

  // Convert minutes since midnight to time string (HH:MM)
  static String minutesToTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return "${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}";
  }

  // Check if a time is within operating hours (using new minutes-based approach)
  static bool isTimeWithinOperatingHours(
    String time,
    OperatingHours operatingHours,
  ) {
    if (operatingHours.isClosed) {
      return false; // Closed
    }

    final timeMinutes = timeToMinutes(time);
    return operatingHours.isWithinHours(timeMinutes);
  }

  // Generate time slots between two times with given interval
  static List<String> generateTimeSlots({
    required String startTime,
    required String endTime,
    int intervalMinutes = 30,
  }) {
    final slots = <String>[];
    final startMinutes = timeToMinutes(startTime);
    final endMinutes = timeToMinutes(endTime);

    for (
      int minutes = startMinutes;
      minutes < endMinutes;
      minutes += intervalMinutes
    ) {
      slots.add(minutesToTime(minutes));
    }

    return slots;
  }

  // Check if two time slots overlap
  static bool doSlotsOverlap({
    required DateTime slot1Start,
    required int slot1Duration,
    required DateTime slot2Start,
    required int slot2Duration,
  }) {
    final slot1End = slot1Start.add(Duration(minutes: slot1Duration));
    final slot2End = slot2Start.add(Duration(minutes: slot2Duration));

    return slot1Start.isBefore(slot2End) && slot2Start.isBefore(slot1End);
  }

  // Get the next available slot after a given time
  static DateTime? getNextAvailableSlot({
    required List<DateTime> availableSlots,
    required DateTime afterTime,
  }) {
    for (final slot in availableSlots) {
      if (slot.isAfter(afterTime)) {
        return slot;
      }
    }
    return null;
  }

  // Round time to nearest interval (e.g., round to nearest 15 minutes)
  static DateTime roundToNearestInterval(
    DateTime dateTime,
    int intervalMinutes,
  ) {
    final minutes = dateTime.minute;
    final roundedMinutes =
        (minutes / intervalMinutes).round() * intervalMinutes;

    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      roundedMinutes % 60,
    ).add(Duration(hours: roundedMinutes ~/ 60));
  }

  // Get weekday from DateTime
  static Weekday getWeekdayFromDateTime(DateTime dateTime) {
    switch (dateTime.weekday) {
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

  // Check if a vet is open on a specific date (using new approach)
  static bool isVetOpenOnDate(
    Map<Weekday, OperatingHours> operatingHours,
    DateTime date,
  ) {
    final weekday = getWeekdayFromDateTime(date);
    final dayHours = operatingHours[weekday];
    return dayHours != null && !dayHours.isClosed;
  }

  // Get operating hours for a specific date
  static OperatingHours? getOperatingHoursForDate(
    Map<Weekday, OperatingHours> operatingHours,
    DateTime date,
  ) {
    final weekday = getWeekdayFromDateTime(date);
    return operatingHours[weekday];
  }

  // Format time range for display
  static String formatTimeRange(String startTime, String endTime) {
    return "$startTime - $endTime";
  }

  // Parse time from DateTime to HH:MM format
  static String formatTimeFromDateTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  // Create DateTime from date and time string
  static DateTime createDateTimeFromTimeString(DateTime date, String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  // Check if time slot is in the past
  static bool isSlotInPast(DateTime slotDateTime) {
    return slotDateTime.isBefore(DateTime.now());
  }

  // Get slots for the next N days
  static List<DateTime> getSlotsForNextDays({
    required Map<Weekday, OperatingHours> operatingHours,
    required int numberOfDays,
    int intervalMinutes = 30,
  }) {
    final slots = <DateTime>[];
    final today = DateTime.now();

    for (int i = 0; i < numberOfDays; i++) {
      final date = today.add(Duration(days: i));
      final weekday = getWeekdayFromDateTime(date);
      final dayHours = operatingHours[weekday];
      if (dayHours != null && !dayHours.isClosed) {
        // Use new minutes-based approach for more efficient slot generation
        final openMinutes = dayHours.openMinutes!;
        final closeMinutes = dayHours.closeMinutes!;

        // Generate slots in intervalMinutes increments
        for (
          int minutes = openMinutes;
          minutes < closeMinutes;
          minutes += intervalMinutes
        ) {
          final slotHour = minutes ~/ 60;
          final slotMinute = minutes % 60;
          final slotDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            slotHour,
            slotMinute,
          );

          if (!isSlotInPast(slotDateTime)) {
            slots.add(slotDateTime);
          }
        }
      }
    }

    return slots;
  }
}
