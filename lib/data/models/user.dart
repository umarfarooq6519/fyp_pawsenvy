class UserAttribute {
  final dynamic icon; // Can be IconData or String (for asset paths)
  final String label;

  UserAttribute({required this.icon, required this.label});

  Map<String, dynamic> toMap() {
    return {'icon': icon, 'label': label};
  }

  factory UserAttribute.fromMap(Map<String, dynamic> map) {
    return UserAttribute(icon: map['icon'], label: map['label'] as String);
  }
}

enum UserRole { petOwner, veterinary }

class User {
  final String name;
  final UserRole role;
  final String location;
  final String gender;
  final String about;
  final List<UserAttribute> attributes;
  final String avatar;

  User({
    required this.name,
    required this.role,
    required this.location,
    required this.gender,
    required this.about,
    required this.attributes,
    required this.avatar,
  });

  String get roleString {
    switch (role) {
      case UserRole.petOwner:
        return 'Pet Owner';
      case UserRole.veterinary:
        return 'Veterinary';
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': roleString,
      'location': location,
      'gender': gender,
      'about': about,
      'attributes': attributes.map((attr) => attr.toMap()).toList(),
      'avatar': avatar,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    UserRole userRole = UserRole.petOwner;
    final roleString = map['role'] as String;
    if (roleString.toLowerCase().contains('vet')) {
      userRole = UserRole.veterinary;
    }

    return User(
      name: map['name'] as String,
      role: userRole,
      location: map['location'] as String,
      gender: map['gender'] as String,
      about: map['about'] as String,
      attributes:
          (map['attributes'] as List<dynamic>)
              .map(
                (attr) => UserAttribute.fromMap(attr as Map<String, dynamic>),
              )
              .toList(),
      avatar: map['avatar'] as String,
    );
  }
}
