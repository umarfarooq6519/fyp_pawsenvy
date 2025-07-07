import 'package:flutter/material.dart';

final List<Map<String, dynamic>> users = [
  {
    'name': 'Alice Johnson',
    'role': 'Pet Owner',
    'location': 'Jakarta',
    'gender': 'Female',
    'about':
        'Loving pet owner with 2 cats and 1 dog. Enjoys volunteering at animal shelters.',
    'attributes': [
      {'icon': 'assets/images/cat.png', 'label': '2 Cats'},
      {'icon': 'assets/images/dog.png', 'label': '1 Dog'},
      {'icon': Icons.watch_later_outlined, 'label': 'Member since 2022'},
    ],
    'avatar': 'assets/images/person1.png',
  },
  {
    'name': 'Dr. Samuel',
    'role': 'Veterinary',
    'location': 'Bandung',
    'gender': 'Male',
    'about':
        'Certified veterinary with 10+ years of experience in animal care and surgery.',
    'attributes': [
      {'icon': Icons.watch_later_outlined, 'label': '10+ yrs exp'},
      {'icon': Icons.verified, 'label': 'Certified'},
      {'icon': Icons.vaccines, 'label': 'Animal Surgery'},
    ],
    'avatar': 'assets/images/person4.png',
  },
  {
    'name': 'Dr. Ayesha',
    'role': 'Veterinary',
    'location': 'Jakarta',
    'gender': 'Female',
    'about':
        'Experienced small animal vet, passionate about preventive care and pet wellness.',
    'attributes': [
      {'icon': Icons.watch_later_outlined, 'label': '8 yrs exp'},
      {'icon': Icons.verified, 'label': 'Certified'},
      {'icon': Icons.pets, 'label': 'Small Animals'},
    ],
    'avatar': 'assets/images/person2.png',
  },
  {
    'name': 'Maria Lopez',
    'role': 'Pet Owner',
    'location': 'Surabaya',
    'gender': 'Female',
    'about':
        'Passionate about animal rescue and fostering. Owns a golden retriever and a parrot.',
    'attributes': [
      {'icon': 'assets/images/dog.png', 'label': '1 Dog'},
      {'icon': Icons.pets, 'label': '1 Parrot'},
      {'icon': Icons.watch_later_outlined, 'label': 'Member since 2021'},
    ],
    'avatar': 'assets/images/person3.png',
  },
];
