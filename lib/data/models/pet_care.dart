class PetCare {
  final String name;
  final String pets;
  final String distance;
  final String? avatar;

  PetCare({
    required this.name,
    required this.pets,
    required this.distance,
    this.avatar,
  });

  List<String> get petTypes {
    return pets.split('|').map((pet) => pet.trim()).toList();
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'pets': pets, 'distance': distance, 'avatar': avatar};
  }

  factory PetCare.fromMap(Map<String, dynamic> map) {
    return PetCare(
      name: map['name'] as String,
      pets: map['pets'] as String,
      distance: map['distance'] as String,
      avatar: map['avatar'] as String?,
    );
  }
}
