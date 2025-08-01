import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/utils/location.util.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/models/vet_profile.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/core/services/auth.service.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/providers/user.provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'complete_user_details.dart';
import 'complete_user_review.dart';
import 'complete_vet_profile.dart';
import 'vet_appointment_schedule.dart';
import 'package:geolocator/geolocator.dart';

class CompleteUserProfile extends StatefulWidget {
  final VoidCallback? onProfileComplete;

  final bool isProfileIncomplete;

  const CompleteUserProfile({
    super.key,
    this.onProfileComplete,
    this.isProfileIncomplete = false,
  });

  @override
  State<CompleteUserProfile> createState() => _CompleteUserProfileState();
}

class _CompleteUserProfileState extends State<CompleteUserProfile> {
  late AuthService _auth;
  late DBService _db;
  late AppUser? _appUser;

  // page controllers
  int currentStep = 0;
  final PageController _pageController = PageController();
  // input controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Vet-specific controllers
  final TextEditingController _clinicNameController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _experienceController = TextEditingController();

  // Form data
  String? _avatarPath;
  GeoPoint? _location;
  DateTime? _dateOfBirth;
  Gender? _selectedGender;
  // Vet-specific form data
  List<Specialization> _selectedSpecializations = [];
  List<Service> _selectedServices = [];
  Map<Weekday, OperatingHours> _operatingHours = {};

  // loading state
  bool isLoading = false;
  // Dynamic step titles based on user role
  List<String> get stepTitles {
    final isVet = _appUser?.userRole == UserRole.vet;
    return isVet
        ? ['Details', 'Vet Details', 'Schedule', 'Review']
        : ['Details', 'Review'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _clinicNameController.dispose();
    _licenseNumberController.dispose();
    _experienceController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _appUser = context.watch<UserProvider>().user;
    _prefillUserData();
  }

  @override
  void initState() {
    super.initState();
    _auth = Provider.of<AuthService>(context, listen: false);
    _db = Provider.of<DBService>(context, listen: false);
  }

  void _prefillUserData() {
    _nameController.text = _appUser?.name ?? '';
    _phoneController.text = _appUser?.phone ?? '';
    _avatarPath = _appUser?.avatar;
    _bioController.text = _appUser?.bio ?? '';

    // Fallback for DOB
    _dateOfBirth = _appUser?.dob ?? Timestamp(0, 0).toDate();

    // Fallback for Gender
    _selectedGender =
        _appUser?.gender == Gender.undefined ? null : _appUser?.gender;

    // Fallback for Location
    _location =
        _appUser?.location ??
        GeoPoint(0, 0); // Prefill vet data if user is a vet
    if (_appUser?.userRole == UserRole.vet && _appUser?.vetProfile != null) {
      _clinicNameController.text = _appUser!.vetProfile!.clinicName;
      _licenseNumberController.text = _appUser!.vetProfile!.licenseNumber;
      _experienceController.text = _appUser!.vetProfile!.experience.toString();
      _selectedSpecializations = List.from(
        _appUser!.vetProfile!.specializations,
      );
      _selectedServices = List.from(_appUser!.vetProfile!.services);
      _operatingHours = Map.from(_appUser!.vetProfile!.operatingHours);
    }
  }

  void _onGenderChange(Gender? gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  Future<void> _onLocationChanged() async {
    try {
      final Position? position = await getCoordinates(context);

      if (position == null) return;

      if (mounted) {
        setState(() {
          _location = GeoPoint(position.latitude, position.longitude);
        });
      }

      // Fetch location name based on coordinates
      if (mounted) {
        final Placemark? place = await getPlacemarkFromCoordinates(
          context,
          position,
        );

        String location =
            '${place?.locality ?? 'Unknown'}, ${place?.administrativeArea ?? 'Unknown'}';

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Location set - $location')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error getting location name')));
      }
    }
  }

  void _onSpecializationsChanged(List<Specialization> specializations) {
    setState(() {
      _selectedSpecializations = specializations;
    });
  }

  void _onServicesChanged(List<Service> services) {
    setState(() {
      _selectedServices = services;
    });
  }

  void _onOperatingHoursChanged(Weekday weekday, String? open, String? close) {
    setState(() {
      // Convert string format to minutes format for efficient storage
      _operatingHours[weekday] = OperatingHours.fromStrings(
        open: open,
        close: close,
      );
    });
  }

  void _onDobChanged(DateTime dateOfBirth) {
    setState(() {
      _dateOfBirth = dateOfBirth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final isVet = userProvider.user?.userRole == UserRole.vet;

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
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentStep = index;
                      });
                    },
                    children: [
                      CompleteUserDetails(
                        nameController: _nameController,
                        phoneController: _phoneController,
                        bioController: _bioController,
                        avatarPath: _avatarPath,
                        location: _location,
                        dateOfBirth: _dateOfBirth,
                        selectedGender: _selectedGender,
                        onGenderChange: _onGenderChange,
                        onLocationChanged: _onLocationChanged,
                        onDobChanged: _onDobChanged,
                      ),
                      if (isVet)
                        CompleteVetProfile(
                          clinicNameController: _clinicNameController,
                          licenseNumberController: _licenseNumberController,
                          experienceController: _experienceController,
                          selectedSpecializations: _selectedSpecializations,
                          selectedServices: _selectedServices,
                          onSpecializationsChanged: _onSpecializationsChanged,
                          onServicesChanged: _onServicesChanged,
                        ),
                      if (isVet)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: VetAppointmentSchedule(
                            operatingHours: _operatingHours,
                            onOperatingHoursChanged: _onOperatingHoursChanged,
                          ),
                        ),
                      CompleteUserReview(
                        userName: _nameController.text,
                        userPhone: _phoneController.text,
                        userBio: _bioController.text,
                        avatarPath: _avatarPath,
                        location: _location,
                        dateOfBirth: _dateOfBirth,
                        onSubmit: _submitForm,
                        isLoading: isLoading,
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
      },
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: FlutterStepIndicator(
        height: 28,
        list: stepTitles,
        onChange: (int index) {
          if (index < currentStep) {
            // Allow going back to previous steps
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        },
        page: currentStep,
        positiveColor: AppColorStyles.deepPurple,
        negativeColor: AppColorStyles.lightGrey,
        progressColor: AppColorStyles.deepPurple,
        positiveCheck: const Icon(Icons.check, color: Colors.white, size: 16),
        division: 2,
      ),
    );
  }

  void _goToNextStep() {
    // Validate current step before proceeding
    if (!_validateForm()) return;

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

    // Check if user is authenticated
    if (_auth.currentUser == null) {
      _showSnackBar('User is not authenticated.');
      return;
    }

    setState(() => isLoading = true);
    try {
      final Map<String, dynamic> updatedFields = {
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'bio': _bioController.text.trim(),
        'gender': _selectedGender?.name ?? Gender.undefined.name,
        'avatar': _avatarPath ?? '',
        'location': _location ?? const GeoPoint(0, 0),
        'dob': _dateOfBirth ?? DateTime.now(),
      }; // Add vet profile data if user is a vet
      if (_appUser?.userRole == UserRole.vet) {
        final vetProfile = VetProfile(
          clinicName: _clinicNameController.text.trim(),
          licenseNumber: _licenseNumberController.text.trim(),
          experience: int.tryParse(_experienceController.text.trim()) ?? 0,
          specializations: _selectedSpecializations,
          services: _selectedServices,
          operatingHours: _operatingHours,
        );
        updatedFields['vetProfile'] = vetProfile.toMap();
      }

      final result = await _db.updateUserFields(
        context,
        _auth.currentUser!.uid,
        updatedFields,
      );

      if (mounted) {
        setState(() => isLoading = false);

        if (result) {
          _showSnackBar('User updated successfully!');

          // Navigate based on callback or go back to let AuthTree handle the updated state
          if (widget.onProfileComplete != null) {
            widget.onProfileComplete!();
          } else {
            // Pop back and let AuthTree rebuild with updated user data
            Navigator.of(context).pop();
          }
        } else {
          _showSnackBar('User update failed!');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        _showSnackBar('Error updating profile: $e');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  bool _validateForm() {
    // Step 0: Basic user details
    if (currentStep == 0) {
      final requiredFields = [
        (_nameController.text.trim(), 'Please enter your name'),
        (_phoneController.text.trim(), 'Please enter your phone number'),
        (_bioController.text.trim(), 'Please enter a bio'),
      ];

      for (final (value, message) in requiredFields) {
        if (value.isEmpty) {
          _showSnackBar(message);
          return false;
        }
      }

      if (_dateOfBirth == Timestamp(0, 0).toDate()) {
        _showSnackBar('Please select your date of birth');
        return false;
      }

      if (_selectedGender == Gender.undefined) {
        _showSnackBar('Please select your gender');
        return false;
      }

      if (_location == GeoPoint(0, 0)) {
        _showSnackBar('Please select your location');
        return false;
      }

      return true;
    }

    // Step 1: Vet details (only for vets)
    if (currentStep == 1 && _appUser?.userRole == UserRole.vet) {
      final vetRequiredFields = [
        (_clinicNameController.text.trim(), 'Please enter your clinic name'),
        (
          _licenseNumberController.text.trim(),
          'Please enter your license number',
        ),
        (
          _experienceController.text.trim(),
          'Please enter your years of experience',
        ),
      ];

      for (final (value, message) in vetRequiredFields) {
        if (value.isEmpty) {
          _showSnackBar(message);
          return false;
        }
      }

      if (_selectedSpecializations.isEmpty) {
        _showSnackBar('Please select at least one specialization');
        return false;
      }

      if (_selectedServices.isEmpty) {
        _showSnackBar('Please select at least one service');
        return false;
      }

      return true;
    }

    // Step 2: Operating hours (only for vets) - No validation needed as operating hours are optional
    if (currentStep == 2 && _appUser?.userRole == UserRole.vet) {
      return true;
    }

    // Final step: All validations for final submission
    if (currentStep == stepTitles.length - 1) {
      // Validate basic fields
      final requiredFields = [
        (_nameController.text.trim(), 'Please enter your name'),
        (_phoneController.text.trim(), 'Please enter your phone number'),
        (_bioController.text.trim(), 'Please enter a bio'),
      ];

      for (final (value, message) in requiredFields) {
        if (value.isEmpty) {
          _showSnackBar(message);
          return false;
        }
      }

      if (_dateOfBirth == Timestamp(0, 0).toDate()) {
        _showSnackBar('Please select your date of birth');
        return false;
      }

      if (_selectedGender == Gender.undefined) {
        _showSnackBar('Please select your gender');
        return false;
      }

      if (_location == GeoPoint(0, 0)) {
        _showSnackBar('Please select your location');
        return false;
      }

      // Validate vet-specific fields if user is a vet
      if (_appUser?.userRole == UserRole.vet) {
        final vetRequiredFields = [
          (_clinicNameController.text.trim(), 'Please enter your clinic name'),
          (
            _licenseNumberController.text.trim(),
            'Please enter your license number',
          ),
          (
            _experienceController.text.trim(),
            'Please enter your years of experience',
          ),
        ];

        for (final (value, message) in vetRequiredFields) {
          if (value.isEmpty) {
            _showSnackBar(message);
            return false;
          }
        }

        if (_selectedSpecializations.isEmpty) {
          _showSnackBar('Please select at least one specialization');
          return false;
        }

        if (_selectedServices.isEmpty) {
          _showSnackBar('Please select at least one service');
          return false;
        }
      }
    }

    return true;
  }

  Widget _buildNavigationButtons() {
    final isLastStep = currentStep == stepTitles.length - 1;
    final isFirstStepWithIncompleteProfile = currentStep == 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 10),
      child: Row(
        mainAxisAlignment:
            isFirstStepWithIncompleteProfile
                ? MainAxisAlignment.end
                : MainAxisAlignment.spaceBetween,
        children: [
          // Back button - hide if on first step with incomplete profile
          if (!isFirstStepWithIncompleteProfile)
            IconButton(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              onPressed:
                  currentStep == 0
                      ? () => Navigator.of(context).pop()
                      : _goToPreviousStep,
              icon: Icon(
                Icons.arrow_back,
                color: AppColorStyles.purple,
                size: 20,
              ),
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                  BorderSide(color: AppColorStyles.purple),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                overlayColor: WidgetStateProperty.all(
                  AppColorStyles.purple.withOpacity(0.1),
                ),
              ),
              tooltip: 'Back',
            ),

          if (!isFirstStepWithIncompleteProfile) const SizedBox(width: 16),

          // Next button (Review button handles submit internally)
          if (!isLastStep)
            ElevatedButton.icon(
              onPressed: isLoading ? null : _goToNextStep,
              icon: Icon(Icons.arrow_forward, color: AppColorStyles.white),
              label: Text(
                'Next',
                style: AppTextStyles.bodyBase.copyWith(
                  color: AppColorStyles.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorStyles.deepPurple,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 30,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
