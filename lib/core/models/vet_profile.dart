enum Weekday { mon, tue, wed, thu, fri, sat, sun }

enum Specialization {
  surgery,
  medicine,
  behavior,
  dentistry,
  dermatology,
  neurology,
  ophthalmology,
}

enum Service { petSitting, petWalking, petGrooming, behaviourTraining }

class VetProfile {
  final String clinicName;
  final String licenseNumber;
  final int experience;
  final Map<Weekday, OperatingHours> operatingHours;
  final List<Specialization> specializations;
  final List<Service> services;

  VetProfile({
    required this.clinicName,
    required this.licenseNumber,
    required this.specializations,
    required this.experience,
    required this.operatingHours,
    required this.services,
  });

  factory VetProfile.fromMap(Map<String, dynamic> data) {
    final hoursMap = Map<String, dynamic>.from(data['operatingHours']);
    final Map<Weekday, OperatingHours> operatingHours = {};
    for (final entry in hoursMap.entries) {
      final weekday = _weekdayFromString(entry.key);
      if (weekday != null) {
        operatingHours[weekday] = OperatingHours.fromMap(
          Map<String, dynamic>.from(entry.value),
        );
      }
    }
    List<Specialization> specializations =
        List<String>.from(data['specializations'])
            .map((e) => _specializationFromString(e))
            .whereType<Specialization>()
            .toList();
    List<Service> services =
        List<String>.from(
          data['services'],
        ).map((e) => _serviceFromString(e)).whereType<Service>().toList();

    return VetProfile(
      clinicName: data['clinicName'] ?? '',
      licenseNumber: data['licenseNumber'] ?? '',
      specializations: specializations,
      experience: data['experience'] ?? 0,
      operatingHours: operatingHours,
      services: services,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clinicName': clinicName,
      'licenseNumber': licenseNumber,
      'specializations': specializations.map((e) => e.name).toList(),
      'experience': experience,
      'operatingHours': operatingHours.map(
        (k, v) => MapEntry(_weekdayToString(k), v.toMap()),
      ),
      'services': services.map((e) => e.name).toList(),
    };
  }
}

class OperatingHours {
  // Store time as minutes since midnight for efficient calculations
  final int? openMinutes; // e.g., 540 for 09:00 (9*60)
  final int? closeMinutes; // e.g., 1020 for 17:00 (17*60)

  OperatingHours({this.openMinutes, this.closeMinutes});

  // Backward compatibility: convert from old string format
  OperatingHours.fromStrings({String? open, String? close})
    : openMinutes = open != null ? _timeStringToMinutes(open) : null,
      closeMinutes = close != null ? _timeStringToMinutes(close) : null;

  // Convert to display format
  String? get open =>
      openMinutes != null ? _minutesToTimeString(openMinutes!) : null;
  String? get close =>
      closeMinutes != null ? _minutesToTimeString(closeMinutes!) : null;

  factory OperatingHours.fromMap(Map<String, dynamic> data) {
    // Handle both old string format and new minutes format
    if (data['openMinutes'] != null && data['closeMinutes'] != null) {
      // New format: minutes since midnight
      return OperatingHours(
        openMinutes: data['openMinutes'],
        closeMinutes: data['closeMinutes'],
      );
    } else {
      // Old format: string time - convert to minutes
      return OperatingHours.fromStrings(
        open: data['open'],
        close: data['close'],
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'openMinutes': openMinutes,
      'closeMinutes': closeMinutes,
      // Keep old format for backward compatibility during migration
      'open': open,
      'close': close,
    };
  }

  // Helper methods for time conversion
  static int _timeStringToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  static String _minutesToTimeString(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return "${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}";
  }

  // Check if time slot is within operating hours
  bool isWithinHours(int timeMinutes) {
    if (openMinutes == null || closeMinutes == null) return false;
    return timeMinutes >= openMinutes! && timeMinutes <= closeMinutes!;
  }

  // Get operating duration in minutes
  int? get durationMinutes {
    if (openMinutes == null || closeMinutes == null) return null;
    return closeMinutes! - openMinutes!;
  }

  // Check if the business is closed
  bool get isClosed => openMinutes == null || closeMinutes == null;
}

Weekday? _weekdayFromString(String value) {
  switch (value.toLowerCase()) {
    case 'mon':
      return Weekday.mon;
    case 'tue':
      return Weekday.tue;
    case 'wed':
      return Weekday.wed;
    case 'thu':
      return Weekday.thu;
    case 'fri':
      return Weekday.fri;
    case 'sat':
      return Weekday.sat;
    case 'sun':
      return Weekday.sun;
    default:
      return null;
  }
}

String _weekdayToString(Weekday weekday) {
  switch (weekday) {
    case Weekday.mon:
      return 'mon';
    case Weekday.tue:
      return 'tue';
    case Weekday.wed:
      return 'wed';
    case Weekday.thu:
      return 'thu';
    case Weekday.fri:
      return 'fri';
    case Weekday.sat:
      return 'sat';
    case Weekday.sun:
      return 'sun';
  }
}

Service? _serviceFromString(String value) {
  switch (value.toLowerCase()) {
    case 'petsitting':
      return Service.petSitting;
    case 'petwalking':
      return Service.petWalking;
    case 'petgrooming':
      return Service.petGrooming;
    case 'behaviourtraining':
      return Service.behaviourTraining;
    default:
      return null;
  }
}

Specialization? _specializationFromString(String value) {
  switch (value.toLowerCase()) {
    case 'surgery':
      return Specialization.surgery;
    case 'dermatology':
      return Specialization.dermatology;
    case 'medicine':
      return Specialization.medicine;
    case 'neurology':
      return Specialization.neurology;
    case 'dentistry':
      return Specialization.dentistry;
    case 'ophthalmology':
      return Specialization.ophthalmology;
    case 'behavior':
      return Specialization.behavior;
    default:
      return null;
  }
}


// ##################### return format #####################

/*

  {
    "clinicName": "Example Clinic",
    "licenseNumber": "ABC123",
    "specializations": ["surgery", "medicine", ...], // as strings
    "services": ["petSitting", "petWalking", ...] // as strings
    "experience": 5,
    "operatingHours": {
      "mon": { 
        "openMinutes": 540,  // 09:00 as minutes since midnight
        "closeMinutes": 1020, // 17:00 as minutes since midnight
        "open": "09:00",     // for backward compatibility
        "close": "17:00"     // for backward compatibility
      },
      "tue": { "openMinutes": 540, "closeMinutes": 1020, "open": "09:00", "close": "17:00" },
      "wed": { "openMinutes": 540, "closeMinutes": 1020, "open": "09:00", "close": "17:00" },
      "thu": { "openMinutes": 540, "closeMinutes": 1020, "open": "09:00", "close": "17:00" },
      "fri": { "openMinutes": 540, "closeMinutes": 1020, "open": "09:00", "close": "17:00" },
      "sat": { "openMinutes": 600, "closeMinutes": 840, "open": "10:00", "close": "14:00" },
      "sun": { "openMinutes": null, "closeMinutes": null, "open": null, "close": null }
    },
  }

*/