import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/services/auth.service.dart';
import 'package:fyp_pawsenvy/core/services/db.service.dart';
import 'package:fyp_pawsenvy/core/theme/color.styles.dart';
import 'package:fyp_pawsenvy/core/theme/text.styles.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/create_user_profile/create_user_profile.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/your_pets_screen.dart';
import 'package:fyp_pawsenvy/presentation/pages/pet_owner/screens/owner_reminders.dart';
import 'package:fyp_pawsenvy/presentation/pages/pet_owner/screens/owner_dashboard.dart';
import 'package:fyp_pawsenvy/presentation/widgets/common/expandable_fab.dart';
import 'package:fyp_pawsenvy/presentation/widgets/common/app_drawer.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/community.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class PetOwner extends StatefulWidget {
  const PetOwner({super.key});

  @override
  State<PetOwner> createState() => _PetOwnerState();
}

class _PetOwnerState extends State<PetOwner> {
  int _selectedIndex = 0;
  final DBService _dbService = DBService();
  bool _profileCheckComplete = false;
  bool _isProfileComplete = false;

  final List<Widget> _screens = [
    OwnerDashboard(),
    Community(),
    OwnerReminders(),
    YourPetsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkProfileCompleteness();
  }

  Future<void> _checkProfileCompleteness() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final User? user = authService.currentUser;

    if (user != null) {
      final isComplete = await _dbService.isUserProfileComplete(user.uid);
      if (mounted) {
        setState(() {
          _isProfileComplete = isComplete;
          _profileCheckComplete = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final User? user = authService.currentUser;

    // Check if user is authenticated
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('User not authenticated')),
      );
    }

    // Show loading while checking profile completeness
    if (!_profileCheckComplete) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }    // If profile is not complete, show CreateUserProfile with callback
    if (!_isProfileComplete) {
      return CreateUserProfile(
        isProfileIncomplete: true, // Hide back button since profile is incomplete
        onProfileComplete: () {
          _checkProfileCompleteness(); // Re-check profile completeness
        },
      );
    }

    return _buildPetOwnerInterface(context, user);
  }

  Widget _buildPetOwnerInterface(BuildContext context, User user) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: const AppDrawer(),
        appBar: AppBar(
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
                            user.photoURL != null
                                ? NetworkImage(user.photoURL!)
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
                    onPressed: () {},
                    icon: Icon(LineIcons.camera, size: 26),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(LineIcons.bell, size: 26),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: _screens[_selectedIndex],
        floatingActionButton:
            _selectedIndex == 2
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
                      onPressed: () {},
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
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
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
      selectedIndex: _selectedIndex,
      onTabChange: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      textStyle: AppTextStyles.bodyExtraSmall,
      tabActiveBorder: Border.all(color: AppColorStyles.grey, width: 1),
      tabs: [
        const GButton(
          icon: LineIcons.home,
          text: 'Home',
          iconColor: Colors.black,
          iconActiveColor: Colors.black,
          border: Border.fromBorderSide(BorderSide.none),
        ),
        const GButton(
          icon: LineIcons.users,
          text: 'Community',
          iconColor: Colors.black,
          iconActiveColor: Colors.black,
          border: Border.fromBorderSide(BorderSide.none),
        ),
        const GButton(
          icon: LineIcons.calendar,
          text: 'Reminders',
          iconColor: Colors.black,
          iconActiveColor: Colors.black,
          border: Border.fromBorderSide(BorderSide.none),
        ),
        GButton(
          icon: Icons.person_outline,
          text: 'Your Pets',
          iconColor: Colors.black,
          iconActiveColor: Colors.black,
          border: Border.fromBorderSide(BorderSide.none),
          leading: const CircleAvatar(
            radius: 11,
            backgroundImage: AssetImage('assets/images/person1.png'),
          ),
        ),
      ],
    );
  }
}
