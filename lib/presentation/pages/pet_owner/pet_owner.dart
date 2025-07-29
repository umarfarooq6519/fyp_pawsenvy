import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/models/app_user.dart';
import 'package:fyp_pawsenvy/core/router/routes.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/core/utils/breed_ai.util.dart';
import 'package:fyp_pawsenvy/presentation/pages/pet_owner/screens/complete_user_profile/complete_user_profile.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/pets_screen.dart';
import 'package:fyp_pawsenvy/presentation/pages/pet_owner/screens/owner_reminders.dart';
import 'package:fyp_pawsenvy/presentation/pages/pet_owner/screens/owner_dashboard.dart';
import 'package:fyp_pawsenvy/presentation/widgets/common/expandable_fab.dart';
import 'package:fyp_pawsenvy/presentation/widgets/common/app_drawer.dart';
import 'package:fyp_pawsenvy/providers/user.provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class PetOwner extends StatefulWidget {
  const PetOwner({super.key});

  @override
  State<PetOwner> createState() => _PetOwnerState();
}

class _PetOwnerState extends State<PetOwner> {
  int _selectedScreen = 0;

  final List<Widget> _screens = [
    OwnerDashboard(),
    OwnerReminders(),
    PetsScreen(),
  ];

  bool _isProfileComplete(AppUser user) {
    final defaultDob = Timestamp(0, 0).toDate();
    final isLocationSet =
        user.location.latitude != 0 || user.location.longitude != 0;

    return user.name.trim().isNotEmpty &&
        user.phone.trim().isNotEmpty &&
        user.avatar.trim().isNotEmpty &&
        user.bio.trim().isNotEmpty &&
        user.gender != Gender.undefined &&
        user.dob != defaultDob &&
        isLocationSet;
  }

  @override
  void initState() {
    super.initState();
    BreedAIUtil.initialize();
  }

  @override
  void dispose() {
    BreedAIUtil.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final appUser = userProvider.user;

        // Show loading if user data is not available yet
        if (appUser == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Check profile completeness in real-time
        if (!_isProfileComplete(appUser)) {
          return CompleteUserProfile(
            isProfileIncomplete: true,
            onProfileComplete: () {
              // The Consumer will automatically rebuild when UserProvider updates
            },
          );
        }

        return _buildPetOwnerInterface(context, appUser);
      },
    );
  }

  Widget _buildPetOwnerInterface(BuildContext context, AppUser user) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: const AppDrawer(),
        appBar: _appBar(context, user),
        body: _screens[_selectedScreen],
        floatingActionButton:
            _selectedScreen == 1
                ? ExpandableFab(
                  distance: 60,
                  children: [
                    ActionButton(
                      onPressed: () {},
                      icon: const Icon(LineIcons.calendar),
                      label: 'Add Booking',
                      backgroundColor: Colors.orange.shade200,
                      iconColor: AppColorStyles.black,
                    ),
                    ActionButton(
                      onPressed: () {
                        context.push(Routes.addReminder);
                      },
                      icon: const Icon(LineIcons.bell),
                      label: 'Add Reminder',
                      backgroundColor: Colors.deepOrange.shade200,
                      iconColor: AppColorStyles.black,
                    ),
                  ],
                )
                : null,
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: _bottomNav(),
        ),
      ),
    );
  }

  GNav _bottomNav() {
    return GNav(
      gap: 6,
      backgroundColor: Colors.transparent,
      color: Colors.black,
      activeColor: Colors.black,
      iconSize: 22,
      tabBackgroundColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      selectedIndex: _selectedScreen,
      onTabChange: (index) {
        setState(() {
          _selectedScreen = index;
        });
      },
      textStyle: AppTextStyles.bodyExtraSmall,
      tabActiveBorder: Border.all(color: AppColorStyles.grey, width: 1),
      tabs: [
        const GButton(icon: LineIcons.users, text: 'Dashboard'),
        const GButton(icon: LineIcons.calendar, text: 'Calendar'),
        GButton(
          icon: Icons.person_outline,
          text: 'Your Pets',
          leading: const CircleAvatar(
            radius: 11,
            backgroundImage: AssetImage('assets/images/person1.png'),
          ),
        ),
      ],
    );
  }

  AppBar _appBar(BuildContext context, AppUser user) {
    return AppBar(
      toolbarHeight: kToolbarHeight + 4,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      scrolledUnderElevation: 0,
      leadingWidth: 78,
      leading: Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Builder(
          builder:
              (context) => InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColorStyles.deepPurple,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage:
                        user.avatar.isNotEmpty
                            ? NetworkImage(user.avatar)
                            : const AssetImage('assets/images/person1.png')
                                as ImageProvider,
                    backgroundColor: AppColorStyles.lightGrey,
                  ),
                ),
              ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Row(
            children: [
              IconButton(
                onPressed: () => predictBreed(),
                icon: const Icon(LineIcons.camera, size: 26),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(LineIcons.bell, size: 26),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ############### Image picker
  final picker = ImagePicker();
  Future<XFile?> pickImageFromGallery() async {
    return await picker.pickImage(source: ImageSource.gallery);
  }

  // ############### Predict breed
  void predictBreed() async {
    // Check if model is loaded, if not try to load it
    if (!BreedAIUtil.isInitialized) {
      debugPrint("Model not loaded, attempting to load...");
      final success = await BreedAIUtil.initialize();

      // If still not loaded, show error
      if (!success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to load AI model. Please try again."),
            ),
          );
        }
        return;
      }
    }

    final image = await pickImageFromGallery();
    if (image == null) {
      debugPrint("Pick image failed");
      return;
    }

    final result = await BreedAIUtil.classifyImage(image.path);
    if (result != null) {
      final breed = result['label'];
      final confidence = result['confidence'];

      debugPrint("Breed: $breed, Confidence: $confidence");

      // Update state and display in UI
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Breed: $breed, Confidence: ${(confidence * 100).toStringAsFixed(1)}%",
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to classify image")),
        );
      }
    }
  }
}
