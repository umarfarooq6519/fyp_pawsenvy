import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/utils/location.util.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/core/services/auth.service.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/providers/user.provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'complete_user_details.dart';
import 'complete_user_review.dart';
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

  // Form data
  String? _avatarPath;
  GeoPoint? _location;
  DateTime? _dateOfBirth;
  Gender? _selectedGender;

  // loading state
  bool isLoading = false;

  // Step titles
  static const List<String> stepTitles = ['Details', 'Review'];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
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
    _location = _appUser?.location ?? GeoPoint(0, 0);
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

  void _onDobChanged(DateTime dateOfBirth) {
    setState(() {
      _dateOfBirth = dateOfBirth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
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
      };

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

  Widget _buildNavigationButtons() {
    final isLastStep = currentStep == stepTitles.length - 1;
    final isFirstStepWithIncompleteProfile =
        currentStep == 0 && widget.isProfileIncomplete;

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
