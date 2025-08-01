import 'package:fyp_pawsenvy/core/models/vet_profile.dart';

/// Utility class for migrating operating hours from string format to minutes format
class OperatingHoursMigration {
  /// Convert old string-based operating hours to new minutes-based format
  static Map<Weekday, OperatingHours> migrateOperatingHours(
    Map<Weekday, OperatingHours> oldOperatingHours,
  ) {
    final Map<Weekday, OperatingHours> migratedHours = {};

    for (final entry in oldOperatingHours.entries) {
      final weekday = entry.key;
      final oldHours = entry.value;

      // If already in new format (has openMinutes), keep as is
      if (oldHours.openMinutes != null && oldHours.closeMinutes != null) {
        migratedHours[weekday] = oldHours;
      } else if (oldHours.open != null && oldHours.close != null) {
        // Convert from old string format to new minutes format
        migratedHours[weekday] = OperatingHours.fromStrings(
          open: oldHours.open,
          close: oldHours.close,
        );
      } else {
        // Closed day
        migratedHours[weekday] = OperatingHours(
          openMinutes: null,
          closeMinutes: null,
        );
      }
    }

    return migratedHours;
  }

  /// Batch migrate vet profiles
  static VetProfile migrateVetProfile(VetProfile oldProfile) {
    return VetProfile(
      clinicName: oldProfile.clinicName,
      licenseNumber: oldProfile.licenseNumber,
      specializations: oldProfile.specializations,
      experience: oldProfile.experience,
      services: oldProfile.services,
      operatingHours: migrateOperatingHours(oldProfile.operatingHours),
    );
  }

  /// Check if operating hours need migration
  static bool needsMigration(Map<Weekday, OperatingHours> operatingHours) {
    for (final hours in operatingHours.values) {
      // If any day has string format but no minutes format, needs migration
      if (hours.open != null && hours.openMinutes == null) {
        return true;
      }
    }
    return false;
  }

  /// Get migration status for debugging
  static Map<String, dynamic> getMigrationStatus(
    Map<Weekday, OperatingHours> operatingHours,
  ) {
    int stringFormat = 0;
    int minutesFormat = 0;
    int closedDays = 0;

    for (final hours in operatingHours.values) {
      if (hours.openMinutes != null && hours.closeMinutes != null) {
        minutesFormat++;
      } else if (hours.open != null && hours.close != null) {
        stringFormat++;
      } else {
        closedDays++;
      }
    }

    return {
      'stringFormat': stringFormat,
      'minutesFormat': minutesFormat,
      'closedDays': closedDays,
      'needsMigration': stringFormat > 0,
      'totalDays': operatingHours.length,
    };
  }
}
