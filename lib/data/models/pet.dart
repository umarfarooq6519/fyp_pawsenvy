import 'package:flutter/material.dart';

class PetAttribute {
  final IconData icon;
  final String label;

  PetAttribute({required this.icon, required this.label});

  Map<String, dynamic> toMap() {
    return {'icon': icon, 'label': label};
  }

  factory PetAttribute.fromMap(Map<String, dynamic> map) {
    return PetAttribute(
      icon: map['icon'] as IconData,
      label: map['label'] as String,
    );
  }
}

class Pet {
  final String name;
  final String type;
  final String location;
  final String breed;
  final String gender;
  final String about;
  final List<PetAttribute> attributes;
  final String avatar;

  Pet({
    required this.name,
    required this.type,
    required this.location,
    required this.breed,
    required this.gender,
    required this.about,
    required this.attributes,
    required this.avatar,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'location': location,
      'breed': breed,
      'gender': gender,
      'about': about,
      'attributes': attributes.map((attr) => attr.toMap()).toList(),
      'avatar': avatar,
    };
  }

  factory Pet.fromMap(Map<String, dynamic> map) {
    return Pet(
      name: map['name'] as String,
      type: map['type'] as String,
      location: map['location'] as String,
      breed: map['breed'] as String,
      gender: map['gender'] as String,
      about: map['about'] as String,
      attributes:
          (map['attributes'] as List<dynamic>)
              .map((attr) => PetAttribute.fromMap(attr as Map<String, dynamic>))
              .toList(),
      avatar: map['avatar'] as String,
    );
  }
}
