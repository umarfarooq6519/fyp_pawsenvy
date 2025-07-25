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
  final String? open;
  final String? close;

  OperatingHours({this.open, this.close});

  factory OperatingHours.fromMap(Map<String, dynamic> data) {
    return OperatingHours(open: data['open'], close: data['close']);
  }

  Map<String, dynamic> toMap() {
    return {'open': open, 'close': close};
  }
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
      "mon": { "open": "09:00", "close": "17:00" },
      "tue": { "open": "09:00", "close": "17:00" },
      "wed": { "open": "09:00", "close": "17:00" },
      "thu": { "open": "09:00", "close": "17:00" },
      "fri": { "open": "09:00", "close": "17:00" },
      "sat": { "open": "10:00", "close": "14:00" },
      "sun": { "open": null, "close": null }
    },
  }

*/