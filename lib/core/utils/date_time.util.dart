/// Date and time utility functions
class DateTimeUtils {
  /// Get weekday name from DateTime
  static String getWeekdayName(DateTime date) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }

  /// Get abbreviated weekday name (first 3 characters)
  static String getAbbreviatedWeekdayName(DateTime date) {
    return getWeekdayName(date).substring(0, 3);
  }

  /// Get month name from DateTime
  static String getMonthName(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[date.month - 1];
  }

  /// Convert 24-hour time format to 12-hour format with AM/PM
  static String formatTime12Hour(String time24) {
    try {
      final parts = time24.split(':');
      if (parts.length != 2) return time24;

      final hour = int.parse(parts[0]);
      final minute = parts[1];

      if (hour == 0) {
        return '12:$minute AM';
      } else if (hour < 12) {
        return '$hour:$minute AM';
      } else if (hour == 12) {
        return '12:$minute PM';
      } else {
        return '${hour - 12}:$minute PM';
      }
    } catch (e) {
      return time24;
    }
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Get formatted date string (e.g., "July 10, 2025")
  static String getFormattedDate(DateTime date) {
    return '${getMonthName(date)} ${date.day}, ${date.year}';
  }

  /// Get date with weekday (e.g., "Monday, July 10")
  static String getDateWithWeekday(DateTime date) {
    return '${getWeekdayName(date)}, ${getMonthName(date)} ${date.day}';
  }
}
