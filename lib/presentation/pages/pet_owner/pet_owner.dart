import 'package:flutter/material.dart';
import 'package:fyp_pawsenvy/core/theme/colors.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/your_pets_screen.dart';
import 'package:fyp_pawsenvy/presentation/pages/pet_owner/screens/owner_reminders.dart';
import 'package:fyp_pawsenvy/presentation/pages/pet_owner/screens/owner_dashboard.dart';
import 'package:fyp_pawsenvy/presentation/widgets/common/expandable_fab.dart';
import 'package:fyp_pawsenvy/presentation/widgets/common/app_drawer.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:fyp_pawsenvy/presentation/pages/common/community.dart';
import 'package:line_icons/line_icons.dart';

class PetOwner extends StatefulWidget {
  const PetOwner({super.key});

  @override
  State<PetOwner> createState() => _PetOwnerState();
}

class _PetOwnerState extends State<PetOwner> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    OwnerDashboard(),
    Community(),
    OwnerReminders(),
    YourPetsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          toolbarHeight: kToolbarHeight + 10,
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
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/person1.png'),
                    ),
                  ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(LineIcons.bell, size: 28),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(LineIcons.camera, size: 28),
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
      iconSize: 24,
      tabBackgroundColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      selectedIndex: _selectedIndex,
      onTabChange: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      tabActiveBorder: Border.all(color: Colors.black54, width: 1),
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
            radius: 14,
            backgroundImage: AssetImage('assets/images/person1.png'),
          ),
        ),
      ],
    );
  }
}
