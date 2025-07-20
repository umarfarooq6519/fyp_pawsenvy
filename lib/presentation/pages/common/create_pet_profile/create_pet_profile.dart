// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/color.styles.dart';
import '../../../../core/theme/text.styles.dart';
import '../../../../core/models/pet.dart';
import '../../../../core/services/auth.service.dart';
import '../../../../core/services/db.service.dart';
import 'add_pet_basic.dart';
import 'add_pet_additional.dart';
import 'add_pet_review.dart';

class CreatePetProfile extends StatefulWidget {
  const CreatePetProfile({super.key});

  @override
  State<CreatePetProfile> createState() => _CreatePetProfileState();
}

class _CreatePetProfileState extends State<CreatePetProfile> {
  var uuid = Uuid();

  int currentStep = 0;
  final PageController _pageController = PageController();

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  // Form data
  String? _selectedGender;
  PetSpecies? _selectedSpecies;
  String? _avatarPath;
  String? _healthRecordsPath;

  final List<String> stepTitles = ['Basic', 'Additional', 'Review'];
  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _colorController.dispose();
    _weightController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorStyles.white,
      body: SafeArea(
        child: Column(
          children: [
            // Step indicator
            _buildStepIndicator(),

            // Form content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentStep = index;
                  });
                },
                children: [
                  AddPetStepOne(
                    nameController: _nameController,
                    bioController: _bioController,
                    selectedGender: _selectedGender,
                    selectedSpecies: _selectedSpecies,
                    avatarPath: _avatarPath,
                    onSpeciesChanged: _onSpeciesChanged,
                    onGenderChanged: _onGenderChanged,
                    onAvatarChanged: _onAvatarChanged,
                  ),
                  AddPetStepTwo(
                    breedController: _breedController,
                    ageController: _ageController,
                    colorController: _colorController,
                    weightController: _weightController,
                    healthRecordsPath: _healthRecordsPath,
                    onPickHealthRecords: _pickHealthRecords,
                  ),
                  AddPetStepThree(
                    petName: _nameController.text,
                    petBio: _bioController.text,
                    selectedGender: _selectedGender,
                    selectedSpecies: _selectedSpecies,
                    avatarPath: _avatarPath,
                    additionalData: {
                      'breed': _breedController.text,
                      'age': _ageController.text,
                      'color': _colorController.text,
                      'weight': _weightController.text,
                      'healthRecords': _healthRecordsPath,
                    },
                    onSubmit: _submitForm,
                  ),
                ],
              ),
            ),

            // Navigation buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        children: [
          for (int i = 0; i < stepTitles.length; i++) ...[
            // Step circle
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color:
                    i <= currentStep
                        ? AppColorStyles.deepPurple
                        : AppColorStyles.lightGrey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child:
                    i < currentStep
                        ? Icon(
                          Icons.check,
                          color: AppColorStyles.white,
                          size: 18,
                        )
                        : Text(
                          '${i + 1}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColorStyles.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
              ),
            ),

            // Line between steps (if not last step)
            if (i < stepTitles.length - 1)
              Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color:
                      i < currentStep
                          ? AppColorStyles.deepPurple
                          : AppColorStyles.lightGrey,
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button (always visible, acts as close if on first step)
          IconButton(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            onPressed: () {
              if (currentStep == 0) {
                Navigator.of(context).pop();
              } else {
                _goToPreviousStep();
              }
            },
            icon: Icon(
              LineIcons.arrowLeft,
              color: AppColorStyles.purple,
              size: 20,
            ),
            style: ButtonStyle(
              side: MaterialStateProperty.all(
                BorderSide(color: AppColorStyles.purple),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(
                AppColorStyles.purple.withOpacity(0.1),
              ),
            ),
            tooltip: 'Back',
          ),

          const SizedBox(width: 16),

          // Next/Continue button
          ElevatedButton.icon(
            onPressed:
                currentStep < stepTitles.length - 1
                    ? _goToNextStep
                    : _submitForm,
            icon: Icon(
              currentStep < stepTitles.length - 1
                  ? LineIcons.arrowRight
                  : LineIcons.check,
              color: AppColorStyles.white,
            ),
            label: Text(
              currentStep < stepTitles.length - 1 ? 'Next' : 'Submit',
              style: AppTextStyles.bodyBase.copyWith(
                color: AppColorStyles.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColorStyles.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickHealthRecords() {
    // Implement image picker for health records
    setState(() {
      _healthRecordsPath = 'assets/images/placeholder.png';
    });
  }

  void _onSpeciesChanged(PetSpecies species) {
    setState(() {
      _selectedSpecies = species;
    });
  }

  void _onGenderChanged(String gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  void _onAvatarChanged(String? avatarPath) {
    setState(() {
      _avatarPath = avatarPath;
    });
  }

  void _goToNextStep() {
    if (currentStep < stepTitles.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToPreviousStep() {
    if (currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitForm() async {
    if (!_validateForm()) return;
    final v4 = uuid.v4();

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final currentUser = authService.currentUser;

      if (currentUser == null) return;

      final Pet newPet = _createPetFromData(currentUser.uid);
      await DBService().addPet(newPet, v4);

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      print('Error saving pet: $e');
    }
  }

  bool _validateForm() {
    return _nameController.text.trim().isNotEmpty &&
        _selectedSpecies != null &&
        _selectedGender != null;
  }

  Pet _createPetFromData(String ownerId) {
    final now = Timestamp.now();
    final v4 = uuid.v4();

    return Pet(
      id: v4,
      ownerId: ownerId,
      name: _nameController.text.trim(),
      species: _selectedSpecies!,
      breed: _breedController.text.trim(),
      age: int.tryParse(_ageController.text) ?? 0,
      gender: _selectedGender!,
      color: _colorController.text.trim(),
      weight: double.tryParse(_weightController.text) ?? 0.0,
      avatar: _avatarPath ?? '',
      bio: _bioController.text.trim(),
      status: PetStatus.normal,
      healthRecords:
          _healthRecordsPath != null ? {'path': _healthRecordsPath} : null,
      createdAt: now,
      updatedAt: now,
    );
  }
}
