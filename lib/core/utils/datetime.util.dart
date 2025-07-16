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

  /// Convert DateTime to 12-hour format with AM/PM
  static String formatTime12Hour(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    if (hour == 0) {
      return '12:$minute AM';
    } else if (hour < 12) {
      return '$hour:$minute AM';
    } else if (hour == 12) {
      return '12:$minute PM';
    } else {
      return '${hour - 12}:$minute PM';
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
