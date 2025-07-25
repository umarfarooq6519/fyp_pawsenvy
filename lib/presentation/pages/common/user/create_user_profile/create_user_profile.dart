import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/services/storage.service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/core/services/auth.service.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'create_user_details.dart';
import 'create_user_review.dart';
import 'package:geolocator/geolocator.dart';

class CreateUserProfile extends StatefulWidget {
  final VoidCallback? onProfileComplete;

  final bool isProfileIncomplete;

  const CreateUserProfile({
    super.key,
    this.onProfileComplete,
    this.isProfileIncomplete = false,
  });

  @override
  State<CreateUserProfile> createState() => _CreateUserProfileState();
}

class _CreateUserProfileState extends State<CreateUserProfile> {
  late AuthService _auth;
  late StorageService _storage;
  late User? _user;

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
  void initState() {
    super.initState();
    _auth = Provider.of<AuthService>(context, listen: false);
    _storage = Provider.of<StorageService>(context, listen: false);
    _user = _auth.currentUser;

    // pre-fill with firebase user data
    _nameController.text = _user?.displayName ?? '';
    _phoneController.text = _user?.phoneNumber ?? '';
    _avatarPath = _user?.photoURL;
  }

  void _onAvatarChanged() async {
    if (_user == null) return;

    final String? url = await _storage.uploadUserAvatar(_user!.uid);

    if (url != null) {
      await _auth.updateUserAvatar(url);
      setState(() {
        _avatarPath = url;
      });
    }
  }

  void _onGenderChange(Gender? gender) {
    setState(() {
      _selectedGender = gender;
    });
  }

  Future<void> _onLocationChanged() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    setState(() {
      _location = GeoPoint(position.latitude, position.longitude);
    });

    // Fetch location name based on coordinates
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String locationName = '${place.locality}, ${place.administrativeArea}';
        _showSnackBar('Location: $locationName');
      }
    } catch (e) {
      _showSnackBar('Failed to fetch location name: $e');
    }
  }

  void _onDobChanged(DateTime dateOfBirth) {
    setState(() {
      _dateOfBirth = dateOfBirth;
    });
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
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentStep = index;
                  });
                },
                children: [
                  CreateUserDetails(
                    nameController: _nameController,
                    phoneController: _phoneController,
                    bioController: _bioController,
                    avatarPath: _avatarPath,
                    location: _location,
                    dateOfBirth: _dateOfBirth,
                    selectedGender: _selectedGender,
                    onGenderChange: _onGenderChange,
                    onAvatarChanged: _onAvatarChanged,
                    onLocationChanged: _onLocationChanged,
                    onDobChanged: _onDobChanged,
                  ),
                  CreateUserReview(
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
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: FlutterStepIndicator(
        height: 20,
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

    setState(() => isLoading = true);

    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final db = Provider.of<DBService>(context, listen: false);
      final currentUser = auth.currentUser;
      if (currentUser == null) return;
      final AppUser user = AppUser(
        userRole: UserRole.owner,
        name: _nameController.text.trim(),
        email: currentUser.email ?? '',
        phone: _phoneController.text.trim(),
        bio: _bioController.text.trim(),
        gender: _selectedGender ?? Gender.undefined,
        avatar: _avatarPath ?? '',
        location: _location ?? const GeoPoint(0, 0),
        createdAt: Timestamp.now(),
        dob: _dateOfBirth ?? DateTime.now(),
        ownedPets: [],
        likedPets: [],
        vetProfile: null,
      );
      await db.addUserToDB(user, currentUser.uid);

      // Profile is now complete, notify parent widget
      if (mounted) {
        widget.onProfileComplete?.call();
      }
    } catch (e) {
      _showSnackBar('Error saving profile: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  bool _validateForm() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final bio = _bioController.text.trim();

    if (name.isEmpty) {
      _showSnackBar('Please enter your name');
      return false;
    }

    if (phone.isEmpty) {
      _showSnackBar('Please enter your phone number');
      return false;
    }

    if (bio.isEmpty) {
      _showSnackBar('Please enter a bio');
      return false;
    }

    if (_dateOfBirth == null) {
      _showSnackBar('Please select your date of birth');
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
