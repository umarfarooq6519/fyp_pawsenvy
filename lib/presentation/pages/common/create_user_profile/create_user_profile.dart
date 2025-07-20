import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/core/services/auth.service.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_user_details.dart';
import 'create_user_review.dart';

class CreateUserProfile extends StatefulWidget {
  final VoidCallback? onProfileComplete;
  /// Set to true when the user profile is incomplete and they shouldn't be able to go back
  /// This will hide the back button on the first step (CreateUserDetails page)
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
  final AuthService auth = AuthService();
  final DBService db = DBService();

  int currentStep = 0;
  final PageController _pageController = PageController();
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
    // Form data
  String? _avatarPath;
  GeoPoint? _location;
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
    // Pre-fill with Firebase user data
    _nameController.text = auth.currentUser?.displayName ?? '';
    _phoneController.text = auth.currentUser?.phoneNumber ?? '';
    _avatarPath = auth.currentUser?.photoURL;
  }  void _onAvatarChanged(String avatarPath) {
    setState(() {
      _avatarPath = avatarPath;
    });
  }

  void _onLocationChanged(GeoPoint location) {
    setState(() {
      _location = location;
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
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentStep = index;
                  });
                },                children: [                  CreateUserDetails(
                    nameController: _nameController,
                    phoneController: _phoneController,
                    bioController: _bioController,
                    avatarPath: _avatarPath,
                    location: _location,
                    onAvatarChanged: _onAvatarChanged,
                    onLocationChanged: _onLocationChanged,
                  ),                  CreateUserReview(
                    userName: _nameController.text,
                    userPhone: _phoneController.text,
                    userBio: _bioController.text,
                    avatarPath: _avatarPath,
                    location: _location,
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
      child: Row(
        children: [
          for (int i = 0; i < stepTitles.length; i++) ...[
            _buildStepCircle(i),
            if (i < stepTitles.length - 1) _buildStepConnector(i),
          ],
        ],
      ),
    );
  }
  
  Widget _buildStepCircle(int index) {
    final isCompleted = index < currentStep;
    final isActive = index <= currentStep;
    
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? AppColorStyles.deepPurple : AppColorStyles.lightGrey,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isCompleted
            ? Icon(
                Icons.check,
                color: AppColorStyles.white,
                size: 18,
              )
            : Text(
                '${index + 1}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColorStyles.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }
  
  Widget _buildStepConnector(int index) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: index < currentStep
            ? AppColorStyles.deepPurple
            : AppColorStyles.lightGrey,
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
      final currentUser = auth.currentUser;
      if (currentUser == null) return;
      final AppUser newAppUser = AppUser(
        id: currentUser.uid,
        userRole:
            UserRole.owner, // Default to owner, role is managed by auth tree
        name: _nameController.text.trim(),
        email: currentUser.email ?? '',
        phone: _phoneController.text.trim(),
        bio: _bioController.text.trim(),
        avatar: _avatarPath ?? '',
        location: _location ?? const GeoPoint(0, 0), // Default location
        createdAt: Timestamp.now(),
        ownedPets: [],
        likedPets: [],
        vetProfile: null,
      );
      await db.addUserToFirestore(newAppUser);

      // Profile is now complete, notify parent widget
      if (mounted) {
        widget.onProfileComplete?.call();
      }    } catch (e) {
      print('Error saving user profile: $e');
      if (mounted) {
        _showSnackBar('Error saving profile: $e');
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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

    return true;
  }    Widget _buildNavigationButtons() {
    final isLastStep = currentStep == stepTitles.length - 1;
    final isFirstStepWithIncompleteProfile = currentStep == 0 && widget.isProfileIncomplete;
    
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 10),
      child: Row(
        mainAxisAlignment: isFirstStepWithIncompleteProfile 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.spaceBetween,
        children: [
          // Back button - hide if on first step with incomplete profile
          if (!isFirstStepWithIncompleteProfile)
            IconButton(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              onPressed: currentStep == 0 
                  ? () => Navigator.of(context).pop()
                  : _goToPreviousStep,
              icon: Icon(Icons.arrow_back, color: AppColorStyles.purple, size: 20),
              style: ButtonStyle(
                side: MaterialStateProperty.all(BorderSide(color: AppColorStyles.purple)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                overlayColor: MaterialStateProperty.all(AppColorStyles.purple.withOpacity(0.1)),
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
                style: AppTextStyles.bodyBase.copyWith(color: AppColorStyles.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorStyles.deepPurple,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
        ],
      ),
    );
  }
}
