import 'package:cloud_firestore/cloud_firestore.dart';

enum PetSpecies { dog, cat }

enum PetStatus { normal, lost, adopted }

class Pet {
  final String id;
  final String ownerId;
  final String avatar;
  final String name;
  final PetSpecies species;
  final String gender; // 'male' | 'female'
  final String breed;
  final String bio;
  final int age;
  final String color;
  final double weight;
  final PetStatus status;
  final Map<String, dynamic>? healthRecords;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Pet({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.gender,
    required this.color,
    required this.weight,
    required this.avatar,
    required this.bio,
    required this.status,
    this.healthRecords,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pet.fromMap(String id, Map<String, dynamic> data) {
    return Pet(
      id: id,
      ownerId: data['ownerId'] ?? '',
      name: data['name'] ?? '',
      species: _petSpeciesFromString(data['species'] ?? 'dog'),
      breed: data['breed'] ?? '',
      age: data['age'] ?? 0,
      gender: data['gender'] ?? '',
      color: data['color'] ?? '',
      weight:
          (data['weight'] is int)
              ? (data['weight'] as int).toDouble()
              : (data['weight'] ?? 0.0),
      avatar: data['avatar'] ?? '',
      bio: data['bio'] ?? '',
      status: _petStatusFromString(data['status'] ?? 'normal'),
      healthRecords:
          data['healthRecords'] is Map<String, dynamic>
              ? Map<String, dynamic>.from(data['healthRecords'])
              : null,
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'species': _petSpeciesToString(species),
      'breed': breed,
      'age': age,
      'gender': gender,
      'color': color,
      'weight': weight,
      'avatar': avatar,
      'bio': bio,
      'status': _petStatusToString(status),
      'healthRecords': healthRecords,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

String _petSpeciesToString(PetSpecies species) {
  switch (species) {
    case PetSpecies.dog:
      return 'dog';
    case PetSpecies.cat:
      return 'cat';
  }
}

PetSpecies _petSpeciesFromString(String species) {
  switch (species) {
    case 'dog':
      return PetSpecies.dog;
    case 'cat':
      return PetSpecies.cat;
    default:
      throw ArgumentError('Unknown species: $species');
  }
}

String _petStatusToString(PetStatus status) {
  switch (status) {
    case PetStatus.normal:
      return 'normal';
    case PetStatus.lost:
      return 'lost';
    case PetStatus.adopted:
      return 'adopted';
  }
}

PetStatus _petStatusFromString(String status) {
  switch (status) {
    case 'normal':
      return PetStatus.normal;
    case 'lost':
      return PetStatus.lost;
    case 'adopted':
      return PetStatus.adopted;
    default:
      throw ArgumentError('Unknown status: $status');
  }
}


// ##################### return format #####################
/*

  {
    "id": "petId123",
    "ownerId": "userId123",
    "name": "Fluffy",
    "species": "dog" | "cat",
    "breed": "Golden Retriever",
    "age": 3,
    "gender": "male" | "female",
    "color": "golden",
    "weight": 12.5, // double
    "avatar": "https://.../pet.png",
    "bio": "Friendly and playful",
    "status": "normal" | "lost" | "adopted",
    "createdAt": Timestamp, // Firestore Timestamp
    "updatedAt": Timestamp 
  }
  
*/