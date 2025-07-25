import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/services/storage.service.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/theme/color.styles.dart';
import '../../../../../core/theme/text.styles.dart';
import '../../../../../core/models/pet.dart';
import '../../../../../core/services/auth.service.dart';
import '../../../../../core/services/db.service.dart';
import 'add_pet_basic.dart';
import 'add_pet_additional.dart';
import 'add_pet_review.dart';

class CreatePetProfile extends StatefulWidget {
  const CreatePetProfile({super.key});

  @override
  State<CreatePetProfile> createState() => _CreatePetProfileState();
}

class _CreatePetProfileState extends State<CreatePetProfile> {
  late AuthService _auth;
  late DBService _db;
  late StorageService _storage;
  late User? _user;

  // page controllers
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
  List<PetTemperament> _selectedTemperaments = [];

  final List<String> steps = ['Basic', 'Additional', 'Review'];

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _colorController.dispose();
    _weightController.dispose();
    _pageController.dispose();
    _auth.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _auth = Provider.of<AuthService>(context, listen: false);
    _db = Provider.of<DBService>(context, listen: false);
    _storage = Provider.of<StorageService>(context, listen: false);
    _user = _auth.currentUser;
    super.initState();
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
                scrollBehavior: null,
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
                    selectedTemperaments: _selectedTemperaments,
                    onPickHealthRecords: _pickHealthRecords,
                    onTemperamentsChanged: _onTemperamentsChanged,
                  ),
                  AddPetStepThree(
                    petName: _nameController.text,
                    petBio: _bioController.text,
                    selectedGender: _selectedGender,
                    selectedSpecies: _selectedSpecies,
                    avatarPath: _avatarPath,
                    selectedTemperaments: _selectedTemperaments,
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
          for (int i = 0; i < steps.length; i++) ...[
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
            if (i < steps.length - 1)
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
              side: WidgetStateProperty.all(
                BorderSide(color: AppColorStyles.purple),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
              overlayColor: WidgetStateProperty.all(
                AppColorStyles.purple.withOpacity(0.1),
              ),
            ),
            tooltip: 'Back',
          ),

          const SizedBox(width: 16),

          // Next/Continue button
          ElevatedButton.icon(
            onPressed:
                currentStep < steps.length - 1 ? _goToNextStep : _submitForm,
            icon: Icon(
              currentStep < steps.length - 1
                  ? LineIcons.arrowRight
                  : LineIcons.check,
              color: AppColorStyles.white,
            ),
            label: Text(
              currentStep < steps.length - 1 ? 'Next' : 'Submit',
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

  void _onAvatarChanged(String uploadedUrl) {
    setState(() {
      _avatarPath = uploadedUrl;
    });
  }

  void _onTemperamentsChanged(List<PetTemperament> temperaments) {
    setState(() {
      _selectedTemperaments = temperaments;
    });
  }

  void _goToNextStep() {
    if (currentStep < steps.length - 1) {
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

    if (_user == null) return;

    final Pet newPet = _createPetFromData(_user!.uid);
    await _db.addPetToDB(newPet);

    if (mounted) Navigator.of(context).pop();
  }

  bool _validateForm() {
    return _nameController.text.trim().isNotEmpty &&
        _selectedSpecies != null &&
        _selectedGender != null;
  }

  Pet _createPetFromData(String ownerId) {
    final now = Timestamp.now();

    return Pet(
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
      temperament: _selectedTemperaments,
      healthRecords:
          _healthRecordsPath != null ? {'path': _healthRecordsPath} : null,
      createdAt: now,
      updatedAt: now,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
