import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_pawsenvy/core/models/vet_profile.dart';

enum UserRole { owner, vet, undefined }

enum Gender { male, female, undefined }

class AppUser {
  final UserRole userRole;
  final String name;
  final String email;
  final String phone;
  final Gender gender;
  final String bio;
  final String avatar;
  final GeoPoint location;
  final Timestamp createdAt;
  final DateTime dob;
  final List<String> ownedPets;
  final List<String> likedPets;
  final VetProfile? vetProfile; // Only for vets

  AppUser({
    required this.userRole,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.bio,
    required this.gender,
    required this.location,
    required this.createdAt,
    required this.dob,
    required this.ownedPets,
    required this.likedPets,
    this.vetProfile,
  });
  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Document data is null');
    }

    return AppUser(
      userRole: userRoleFromString(data['userType'] ?? 'undefined'),
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      avatar: data['avatar'] ?? '',
      bio: data['bio'] ?? '',
      gender: genderFromString(data['gender'] ?? 'undefined'),
      location: data['location'] ?? const GeoPoint(0, 0),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      dob:
          data['dob'] != null
              ? (data['dob'] as Timestamp).toDate()
              : Timestamp(0, 0).toDate(),
      ownedPets: List<String>.from(data['ownedPets'] ?? []),
      vetProfile:
          data['vetProfile'] != null
              ? VetProfile.fromMap(data['vetProfile'])
              : null,
      likedPets: List<String>.from(data['likedPets'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userType': userRole.name,
      'name': name,
      'email': email,
      'phone': phone,
      'bio': bio,
      'avatar': avatar,
      'gender': gender.name,
      'location': location,
      'createdAt': createdAt,
      'dob': Timestamp.fromDate(dob),
      'ownedPets': ownedPets,
      'likedPets': likedPets,
      if (vetProfile != null) 'vetProfile': vetProfile!.toMap(),
    };
  }
}

UserRole userRoleFromString(String value) {
  switch (value) {
    case 'vet':
      return UserRole.vet;
    case 'owner':
      return UserRole.owner;
    case 'undefined':
    default:
      return UserRole.undefined;
  }
}

Gender genderFromString(String value) {
  switch (value.toLowerCase()) {
    case 'female':
      return Gender.female;
    case 'male':
      return Gender.male;
    case 'undefined':
    default:
      return Gender.undefined;
  }
}

// ##################### return format #####################
/*

  {
    "userType": "owner" | "vet" | "undefined",
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "bio": "Short bio here",
    "avatar": "https://.../avatar.png",
    "gender": "male" | "female",
    "location": GeoPoint(latitude, longitude), // Firestore GeoPoint object
    "createdAt": Timestamp, // Firestore Timestamp object
    "dob": Timestamp, // Firestore Timestamp object
    "ownedPets": ["petId1", "petId2", ...], // List of pet IDs
    "likedPets": ["petId3", "petId4", ...],

    // Only if userType is "vet"
    "vetProfile": {
      // See VetProfile return format for details
    }
  }

*/
