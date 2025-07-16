import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_pawsenvy/core/models/vet_profile.dart';

enum UserRole { owner, vet }

class AppUser {
  final String id;
  final UserRole userRole;
  final String name;
  final String email;
  final String phone;
  final String bio;
  final String avatar;
  final GeoPoint location;
  final Timestamp createdAt;
  final List<String> ownedPets;
  final List<String> likedPets;
  final VetProfile? vetProfile; // Only for vets

  AppUser({
    required this.id,
    required this.userRole,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.bio,
    required this.location,
    required this.createdAt,
    required this.ownedPets,
    required this.likedPets,
    this.vetProfile,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> data) {
    return AppUser(
      id: id,
      userRole: _userRoleFromString(data['userType'] ?? 'owner'),
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      avatar: data['avatar'] ?? '',
      bio: data['bio'] ?? '',
      location: data['location'] ?? const GeoPoint(0, 0),
      createdAt: data['createdAt'] ?? Timestamp.now(),
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
      'location': location,
      'createdAt': createdAt,
      'ownedPets': ownedPets,
      'likedPets': likedPets,
      if (vetProfile != null) 'vetProfile': vetProfile!.toMap(),
    };
  }
}

UserRole _userRoleFromString(String value) {
  switch (value) {
    case 'vet':
      return UserRole.vet;
    case 'owner':
    default:
      return UserRole.owner;
  }
}



// ##################### return format #####################
/*
  {
    "userType": "owner" | "vet",
    "name": "John Doe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "bio": "Short bio here",
    "avatar": "https://.../avatar.png",
    "location": GeoPoint(latitude, longitude), // Firestore GeoPoint object
    "createdAt": Timestamp, // Firestore Timestamp object
    "ownedPets": ["petId1", "petId2", ...], // List of pet IDs
    "likedPets": ["petId3", "petId4", ...],

    // Only if userType is "vet"
    "vetProfile": {
      // See VetProfile return format for details
    }
  }
*/